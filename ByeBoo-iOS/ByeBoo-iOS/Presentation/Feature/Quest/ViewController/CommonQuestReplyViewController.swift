//
//  CommonQuestReplyViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/8/26.
//

import Combine
import UIKit

final class CommonQuestReplyViewController: BaseViewController {
    
    private let rootView = CommonQuestReplyView()
    private let viewModel: CommonQuestReplyViewModel
    
    private var commentEntity: CommonQuestCommentEntity? = nil
    private var commentID: Int = 0
    private var editingCommentID: Int?
    
    var onReplyCountChanged: ((Int, Int) -> Void)?
    
    private var dataSource: UITableViewDiffableDataSource<ReplySection, CommentItem>!
    private var cancellable = Set<AnyCancellable>()
    
    var onDismiss: (() -> Void)?
    
    init(viewModel: CommonQuestReplyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        addKeyboardObservers()
        
        viewModel.action(.fetchReplyList(commentID: commentID))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    override func setAddTarget() {
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    override func setDelegate() {
        rootView.commentListView.do {
            $0.separatorStyle = .none
            $0.register(CommentTableViewCell.self, forCellReuseIdentifier: "comment")
            $0.register(CommentTableViewCell.self, forCellReuseIdentifier: "reply")
        }
        rootView.commentTextView.delegate = self
    }
}

extension CommonQuestReplyViewController {
    func configure(
        entity: CommonQuestCommentEntity,
        commentID: Int
    ) {
        self.commentEntity = entity
        self.commentID = commentID
        viewModel.setComment(entity)
    }
    
    private func bind() {
        viewModel.output.fetchReplyListPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let replyList):
                    if let cell = self?.rootView.commentListView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CommentTableViewCell {
                        cell.updateReplyCount(replyCount: replyList.totalCount)
                    }
                    self?.applySnapshot(entity: replyList.replies)
                    self?.onReplyCountChanged?(self?.commentID ?? 0, replyList.totalCount)
                case .failure(let error):
                    ByeBooLogger.debug(error)
                }
            }
            .store(in: &cancellable)
        
        viewModel.output.postReplyPublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success:
                    ByeBooLogger.debug("답글 입력 성공")
                case .failure(let error):
                    ByeBooLogger.debug(error)
                }
            }
            .store(in: &cancellable)
        
        viewModel.output.patchReplyPublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success:
                    ByeBooLogger.debug("답글 수정 성공")
                case .failure(let error):
                    ByeBooLogger.debug(error)
                }
            }
            .store(in: &cancellable)
        
    }
}

extension CommonQuestReplyViewController {
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<ReplySection, CommentItem>(
            tableView: rootView.commentListView
        ) { tableView, indexPath, item in
            let identifier = item.entity.replyCount != nil ? "comment" : "reply"
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: identifier,
                for: indexPath
            ) as? CommentTableViewCell else { return UITableViewCell() }
            
            let entity = item.entity
            cell.configure(
                isMyComment: entity.isMyComment,
                commentID: entity.commentID,
                replyCount: entity.replyCount,
                writer: entity.writer,
                profileIcon: ProfileIcon.image(for: entity.profileIcon) ?? .relievedBadge,
                writtenAt: ServerDateFormatter.shared.relativeTimeString(from: entity.writtenAt) ?? "",
                content: entity.content,
                showAllText: item.showAllText,
                isReplySheet: true
            )
            cell.delegate = self
            return cell
        }
    }
    
    private func applySnapshot(entity: [CommonQuestCommentEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<ReplySection, CommentItem>()
        snapshot.appendSections([.comment, .replies])
        
        guard let commentEntity else { return }
        let commentItem = CommentItem(entity: commentEntity, showAllText: false)
        snapshot.appendItems([commentItem], toSection: .comment)
        
        let replyItems = entity.map { CommentItem(entity: $0, showAllText: false) }
        snapshot.appendItems(replyItems, toSection: .replies)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func commonBottomSheetUp(commentID: Int, isMyComment: Bool) {
        let commonQuestBottomSheet = ViewControllerFactory.shared.makeCommonQuestBottomSheetViewController()
        
        guard let comment = viewModel.getComment(commentID: commentID) else { return }
        commonQuestBottomSheet.configure(
            sheetType: isMyComment ? .myComment : .otherComment ,
            targetID: commentID,
            writerID: comment.writerID,
            content: comment.content
        )
        
        setDelegate(bottomSheet: commonQuestBottomSheet)
        presentBottomSheet(commonQuestBottomSheet, height: 224.adjustedH)
    }
    
    @objc
    private func backButtonDidTap() {
        self.dismiss(animated: true)
        onDismiss?()
    }
}

extension CommonQuestReplyViewController: CommentProtocol {
    func menuButtonDidTap(commentID: Int, isMyComment: Bool) {
        commonBottomSheetUp(commentID: commentID, isMyComment: isMyComment)
    }
    
    func moreLabelDidTap(commentID: Int) {
        let currentSnapshot = dataSource.snapshot()
        
        let commentItems = currentSnapshot.itemIdentifiers(inSection: .comment).map { item -> CommentItem in
            guard item.entity.commentID == commentID else { return item }
            return CommentItem(entity: item.entity, showAllText: true)
        }
        let replyItems = currentSnapshot.itemIdentifiers(inSection: .replies).map { item -> CommentItem in
            guard item.entity.commentID == commentID else { return item }
            return CommentItem(entity: item.entity, showAllText: true)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<ReplySection, CommentItem>()
        snapshot.appendSections([.comment, .replies])
        snapshot.appendItems(commentItems, toSection: .comment)
        snapshot.appendItems(replyItems, toSection: .replies)
        dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
            self?.rootView.commentListView.performBatchUpdates(nil)
        }
    }
}

extension CommonQuestReplyViewController: EditCommonQuestProtocol {
    func didTapCommonQuestEdit(
        answerID: Int,
        answer: String,
        question: String,
        writtenAt: String
    ) {
        let writeCommonQuestViewController = ViewControllerFactory.shared.makeWriteQuestionTypeQuestViewController()
        writeCommonQuestViewController.navigationItem.hidesBackButton = true
        writeCommonQuestViewController.questScope = .common
        writeCommonQuestViewController.configureToEdit(
            questNumber: nil,
            questType: .question,
            questionTitle: question,
            answerID: answerID,
            answer: answer,
            writtenAt: writtenAt
        )
        self.navigationController?.pushViewController(writeCommonQuestViewController, animated: false)
    }
    
    func didTapCommentEdit(commentID: Int, content: String) {
        editingCommentID = commentID
        rootView.commentTextView.configureWhenEdit(content: content)
        rootView.commentTextView.textView.becomeFirstResponder()
    }
    
    @objc
    private func bottomUp() {
        guard let commentEntity else { return }
        commonBottomSheetUp(commentID: commentID, isMyComment: commentEntity.isMyComment)
    }
    
    private func setDelegate(bottomSheet: CommonQuestBottomSheetViewController) {
        bottomSheet.do {
            $0.editDelegate = self
            $0.deleteDelegate = self
            $0.blockDelegate = self
        }
    }
}

extension CommonQuestReplyViewController: CommonQuestCommentProtcol {
    func postComment(content: String) {
        viewModel.action(.postReply(commentID: commentID, content: content))
    }
    
    func editComment(content: String) {
        guard let editingCommentID else { return }
        viewModel.action(.editReply(commentID: commentID, editingCommentID: editingCommentID, content: content))
    }
}

extension CommonQuestReplyViewController: DeleteCommonQuestDelegate {
    func completeDeleteCommonQuest(deletedID: Int) {
        if deletedID == self.commentID {
            dismiss(animated: true)
            onDismiss?()
        } else {
            viewModel.action(.fetchReplyList(commentID: commentID))
        }
    }
}

extension CommonQuestReplyViewController: BlockReportProtocol {
    func completeBlockReport(type: CommonQuestArchiveType.Action) {
        ViewControllerUtils.changeQuestTabWithIndex(index: 1) {
            NotificationCenter.default.post(
                name: .showToastMessage,
                object: nil,
                userInfo: ["type": type]
            )
        }
    }
}

extension CommonQuestReplyViewController: KeyboardHandleProtocol  {
    func keyboardWillShowOrHide(height: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration) {
            self.rootView.updateLayout(keyboardHeight: height)
            self.rootView.layoutIfNeeded()
        }
    }
}
