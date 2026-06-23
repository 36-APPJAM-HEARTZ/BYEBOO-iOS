//
//  CommonQuestHistoryViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import Combine
import UIKit

import Mixpanel

final class CommonQuestHistoryViewController: BaseViewController {
    
    private var dataSource: UITableViewDiffableDataSource<CommentSection, CommentItem>!
    private var cancellable = Set<AnyCancellable>()
    
    private let rootView = CommonQuestHistoryView()
    private let viewModel: CommonQuestHistoryViewModel
    
    init(viewModel: CommonQuestHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var answerID: Int = 0
    private var writerID: Int = 0
    private var editingCommentID: Int?
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        addKeyboardObservers()
        
        viewModel.action(.fetchQuestDetail(answerID: answerID))
        
        Mixpanel.mainInstance().track(event: CommonJourneyEvents.Name.commonJourneyOthersAnswerPageview)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .backAndMenu(header: .black),
            action: #selector(back),
            secondAction: #selector(bottomUp)
        )
        
        bind()
        
        configureDataSource()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    override func setAddTarget() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        rootView.scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func setDelegate() {
        rootView.commentListView.do {
            $0.separatorStyle = .none
            $0.register(CommentTableViewCell.self)
        }
        rootView.questContentView.delegate = self
        rootView.commentTextView.delegate = self
    }
}

extension CommonQuestHistoryViewController {
    func configure(answerID: Int) {
        self.answerID = answerID
    }
}

extension CommonQuestHistoryViewController: BackNavigable {
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension CommonQuestHistoryViewController {
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<CommentSection, CommentItem>(
            tableView: rootView.commentListView
        ) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentTableViewCell.identifier,
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
                isReplySheet: false
            )
            cell.delegate = self
            return cell
        }
    }
    
    private func applySnapshot(commentList: [CommonQuestCommentEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<CommentSection, CommentItem>()
        snapshot.appendSections([.main])
        let items = commentList.map { CommentItem(entity: $0, showAllText: false) }
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension CommonQuestHistoryViewController: EditCommonQuestProtocol {
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
        commonBottomSheetUp()
    }
    
    private func setDelegate(bottomSheet: CommonQuestBottomSheetViewController) {
        bottomSheet.do {
            $0.editDelegate = self
            $0.deleteDelegate = self
            $0.blockDelegate = self
        }
    }
}

extension CommonQuestHistoryViewController: DeleteCommonQuestDelegate {
    func completeDeleteCommonQuest(deletedID: Int) {
        ByeBooLogger.debug("댓글 삭제 완료")
        viewModel.action(.fetchQuestDetail(answerID: answerID))
    }
}

extension CommonQuestHistoryViewController: CommentProtocol {
    func moreLabelDidTap(commentID: Int) {
        let updatedItems = dataSource.snapshot().itemIdentifiers.map { item -> CommentItem in
            guard item.entity.commentID == commentID else { return item }
            return CommentItem(entity: item.entity, showAllText: true)
        }

        var snapshot = NSDiffableDataSourceSnapshot<CommentSection, CommentItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(updatedItems, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
            self?.rootView.commentListView.performBatchUpdates(nil)
        }
    }
    
    func replyIconDidTap(commentID: Int) {
        let viewController = ViewControllerFactory.shared.makeCommonQuestReplyViewController()
        let entity = viewModel.getComment(commentID: commentID)
        guard let entity else { return }
        viewController.configure(entity: entity, commentID: commentID)

        viewController.onReplyCountChanged = { [weak self] commentID, newCount in
            guard let self else { return }
            let item = dataSource.snapshot().itemIdentifiers.first { $0.entity.commentID == commentID }
            guard let item,
                  let indexPath = dataSource.indexPath(for: item),
                  let cell = rootView.commentListView.cellForRow(at: indexPath) as? CommentTableViewCell
            else { return }
            cell.updateReplyCount(replyCount: newCount)
        }
        
        viewController.onDismiss = { [weak self] in
            guard let self else { return }
            viewModel.action(.fetchQuestDetail(answerID: answerID))
        }

        if let sheet =  viewController.sheetPresentationController{
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        self.present(viewController, animated: true)
    }
    
    func menuButtonDidTap(commentID: Int, isMyComment: Bool) {
        commonBottomSheetUp(commentID: commentID, isMyComment: isMyComment)
    }
}

extension CommonQuestHistoryViewController: BlockReportProtocol {
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

extension CommonQuestHistoryViewController: CommonQuestCommentProtcol {
    func postComment(content: String) {
        viewModel.action(.postComment(answerID: answerID, content: content))
    }
    
    func editComment(content: String) {
        guard let editingCommentID else { return }
        viewModel.action(.patchComment(answerID: answerID, commentID: editingCommentID , content: content))
    }
}

extension CommonQuestHistoryViewController {
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func bind() {
        viewModel.output.fetchCommonQuestDetailPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let entity):
                    self?.bindData(entity: entity)
                    self?.applySnapshot(commentList: entity.comments)
                case .failure(let error):
                    ByeBooLogger.debug(error)
                }
            }
            .store(in: &cancellable)
        
        viewModel.output.commonQuestLikeCountPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let result):
                    let entity = result.entity
                    self?.rootView.questContentView.updateUI(likeCount: entity.likeCount, isLiked: entity.isLiked)
                case .failure(let error):
                    ByeBooLogger.error(error)
                }
            }
            .store(in: &cancellable)
        
        viewModel.output.postCommentPublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success:
                    ByeBooLogger.debug("댓글 입력 성공")
                case .failure(let error):
                    ByeBooLogger.debug(error)
                }
            }
            .store(in: &cancellable)
        
        viewModel.output.patchCommentPublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success:
                    ByeBooLogger.debug("댓글 수정 성공")
                case .failure(let error):
                    ByeBooLogger.debug(error)
                }
            }
            .store(in: &cancellable)
    }
    
    private func bindData(entity: CommonQuestDetailEntity) {
        let answer = entity.answer
        self.writerID = answer.writerID
        
        rootView.configure(
            answerID: answerID,
            question: entity.question,
            writtenAt: ServerDateFormatter.shared.relativeTimeString(from: answer.writtenAt) ?? "", //TODO: ViewModel로 수정
            profileIcon: ProfileIcon.image(for: answer.profileIcon) ?? .relievedBadge,
            nickname: answer.writer,
            content: answer.content,
            isLiked: answer.isLiked,
            likeCount: answer.likeCount,
            commentCount: answer.commentCount
        )
    }
    
    private func commonBottomSheetUp(commentID: Int? = nil, isMyComment: Bool? = nil) {
        let commonQuestBottomSheet = ViewControllerFactory.shared.makeCommonQuestBottomSheetViewController()
        
        if let commentID, let isMyComment{
            configureWhenComment(commentID: commentID, isMyComment: isMyComment, sheet: commonQuestBottomSheet)
        } else {
            configureWhenCommonQuest(sheet: commonQuestBottomSheet)
        }
        
        setDelegate(bottomSheet: commonQuestBottomSheet)
        presentBottomSheet(commonQuestBottomSheet, height: 224.adjustedH)
    }
    
    private func configureWhenComment(
        commentID: Int,
        isMyComment: Bool,
        sheet: CommonQuestBottomSheetViewController
    ) {
        let content = viewModel.getComment(commentID: commentID)?.content
        sheet.configureWhenComment(
            sheetType: isMyComment ? .myComment : .otherComment ,
            targetID: commentID,
            writerID: writerID,
            content: content
        )
    }
    
    private func configureWhenCommonQuest(sheet: CommonQuestBottomSheetViewController) {
        let entity = viewModel.detailEntity
        guard let entity else { return }
        
        let sheetType: CommonQuestArchiveType = entity.isMyAnswer ? .myAnswer : .otherAnswer
        sheet.configureWhenComment(
            sheetType: sheetType,
            targetID: answerID,
            writerID: writerID
        )
        
        if entity.isMyAnswer {
            sheet.configureWhenQuestEdit(
                sheeetType: sheetType,
                answerID: answerID,
                answer: entity.content,
                question: viewModel.question,
                writtenAt: entity.writtenAt
            )
        }
    }
}

extension CommonQuestHistoryViewController: KeyboardHandleProtocol {
    func keyboardWillShowOrHide(height: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration) {
            self.rootView.updateLayout(keyboardHeight: height)
            self.rootView.layoutIfNeeded()
        }
    }
}

extension CommonQuestHistoryViewController: CommonQuestLikeProtocol {
    func likeButtonDidTap(answerID: Int) {
        viewModel.action(.likeButtonDidTap(answerID: answerID))
    }
}
