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
    
    private var isMyAnswer: Bool = false
    
    private var nickname: String = ""
    private var profileIcon: UIImage?
    var answerID: Int?
    private var answer: String?
    private var question: String?
    private var writtenAt: String?
    private var commonQuestArchiveType: CommonQuestArchiveType = .myAnswer
    private var writerID: Int = 0
    private var isLiked: Bool = false
    private var likeCount: Int = 0
    private var commentCount: Int = 0
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        addKeyboardObservers()
        
        viewModel.action(.viewWillAppear(answerID: answerID ?? 0))
        bind()
        
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
        
        configureDataSource()
//        applySnapshot()
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

extension CommonQuestHistoryViewController: CommonQuestBottomSheetDelegate {
    
    func didTapEdit(
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
            writtenAt: writtenAt,
            nickname: nickname,
            profileIcon: profileIcon ?? .relievedBadge,
            isLiked: isLiked,
            likeCount: likeCount,
            commentCount: commentCount
        )
        self.navigationController?.pushViewController(writeCommonQuestViewController, animated: false)
    }
    
    @objc
    private func bottomUp() {
        commonBottomSheetUp()
    }
    
    private func setDelegate(bottomSheet: CommonQuestBottomSheetViewController) {
        bottomSheet.do {
            $0.bottomDelegate = self
            $0.deleteDelegate = self
            $0.blockDelegate = self
        }
    }
}

extension CommonQuestHistoryViewController: DeleteCommonQuestDelegate {
    func completeDeleteCommonQuest() {
        self.navigationController?.popViewController(animated: false)
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
        let viewController = CommonQuestReplyViewController()
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

extension CommonQuestHistoryViewController {
    
    func configure(
        question: String,
        writtenAt: String,
        profileIcon: UIImage,
        nickname: String,
        content: String,
        answerID: Int? = nil,
        writerID: Int? = nil,
        isMyAnswer: Bool,
        isLiked: Bool,
        likeCount: Int,
        commentCount: Int
    ) {
        self.nickname = nickname
        self.profileIcon = profileIcon
        self.answerID = answerID
        self.answer = content
        self.question = question
        self.writtenAt = writtenAt
        self.isMyAnswer = isMyAnswer
        
        commonQuestArchiveType = isMyAnswer ? .myAnswer : .otherAnswer
        
        if let writerID {
            self.writerID = writerID
        }

        self.isLiked = isLiked
        self.likeCount = likeCount
        self.commentCount = commentCount

        rootView.configure(
            question: question,
            writtenAt: writtenAt,
            profileIcon: profileIcon,
            nickname: nickname,
            content: content,
            isLiked: isLiked,
            likeCount: likeCount,
            commentCount: commentCount
        )
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

extension CommonQuestHistoryViewController {
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func bind() {
        viewModel.output.fetchCommonQuestCommentsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let commentList):
                    self?.applySnapshot(commentList: commentList)
                case .failure(let error):
                    ByeBooLogger.debug(error)
                }
            }
            .store(in: &cancellable)
    }
    
    private func commonBottomSheetUp(commentID: Int? = nil, isMyComment: Bool? = nil) {
        let commonQuestBottomSheet = ViewControllerFactory.shared.makeCommonQuestBottomSheetViewController()
        if isMyAnswer {
            commonQuestBottomSheet.configureWhenEdit(
                sheeetType: commonQuestArchiveType,
                answerID: answerID,
                answer: answer,
                question: question,
                writtenAt: writtenAt
            )
        }
        
        if let commentID, let isMyComment {
            commonQuestBottomSheet.configure(
                sheeetType: isMyComment ? .myComment : .otherComment ,
                targetID: writerID
            )
        } else {
            commonQuestBottomSheet.configure(sheeetType: commonQuestArchiveType, targetID: writerID)
        }
        
        setDelegate(bottomSheet: commonQuestBottomSheet)
        
        if let sheet =  commonQuestBottomSheet.sheetPresentationController{
            sheet.detents = [.custom { _ in 224.adjustedH }]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 8
        }
        self.present(commonQuestBottomSheet, animated: true)
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
