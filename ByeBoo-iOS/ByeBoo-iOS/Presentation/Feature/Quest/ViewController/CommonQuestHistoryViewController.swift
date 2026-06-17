//
//  CommonQuestHistoryViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import UIKit

import Mixpanel

final class CommonQuestHistoryViewController: BaseViewController {
    
    private var dataSource: UITableViewDiffableDataSource<CommentSection, CommentItem>!
    
    private let rootView = CommonQuestHistoryView()
    private let viewModel: CommonQuestHistoryViewModel
    
    private var answerID: Int?
    private var answer: String?
    private var question: String?
    private var writtenAt: String?
    private var commonQuestArchiveType: CommonQuestArchiveType = .mine
    private var writerID: Int = 0
    
    init(viewModel: CommonQuestHistoryViewModel) {
        self.viewModel = viewModel
        super.init()
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
        applySnapshot()
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
                commentID: entity.commentID,
                replyCount: entity.replyCount,
                writer: entity.writer,
                profileIcon: ProfileIcon.image(for: entity.profileIcon) ?? .relievedBadge,
                writtenAt: entity.writtenAt,
                content: entity.content,
                showAllText: item.showAllText,
                isReplySheet: false
            )
            cell.delegate = self
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<CommentSection, CommentItem>()
        snapshot.appendSections([.main])
        let items = viewModel.commentLists.map { CommentItem(entity: $0, showAllText: false) }
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
            nil, .question, question, answerID, answer, writtenAt
        )
        self.navigationController?.pushViewController(writeCommonQuestViewController, animated: false)
    }
    
    @objc
    private func bottomUp() {
        let commonQuestBottomSheet = ViewControllerFactory.shared.makeCommonQuestBottomSheetViewController()
        commonQuestBottomSheet.configure(sheeetType: commonQuestArchiveType, writerID: writerID)
        commonQuestBottomSheet.configure(
            sheeetType: commonQuestArchiveType,
            answerID: answerID,
            answer: answer,
            question: question,
            writtenAt: writtenAt
        )
        setDelegate(bottomSheet: commonQuestBottomSheet)
        
        if let sheet =  commonQuestBottomSheet.sheetPresentationController{
            sheet.detents = [.custom { _ in 224.adjustedH }]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 8
        }
        self.present(commonQuestBottomSheet, animated: true)
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
        isMyAnswer: Bool? = nil
    ) {
        self.answerID = answerID
        self.answer = content
        self.question = question
        self.writtenAt = writtenAt
        
        if let isMyAnswer {
            commonQuestArchiveType = isMyAnswer ? .mine : .other
        }
        
        if let writerID {
            self.writerID = writerID
        }
        
        rootView.configure(
            question: question,
            writtenAt: writtenAt,
            profileIcon: profileIcon,
            nickname: nickname,
            content: content,
            isLiked: false,
            likeCount: 4,
            commentCount: 5
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
}

extension CommonQuestHistoryViewController: KeyboardHandleProtocol {
    func keyboardWillShowOrHide(height: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration) {
            self.rootView.updateLayout(keyboardHeight: height)
            self.rootView.layoutIfNeeded()
        }
    }
}
