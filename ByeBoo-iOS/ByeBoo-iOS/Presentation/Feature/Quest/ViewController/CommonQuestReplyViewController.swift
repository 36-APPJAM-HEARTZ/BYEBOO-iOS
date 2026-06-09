//
//  CommonQuestReplyViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/8/26.
//

import UIKit

final class CommonQuestReplyViewController: BaseViewController {
    
    private let rootView = CommonQuestReplyView()
    private let viewModel = CommonQuestReplyViewModel()
    
    private var dataSource: UITableViewDiffableDataSource<ReplySection, CommentItem>!
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        addKeyboardObservers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        applySnapshot()
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
                writtenAt: entity.writtenAt,
                content: entity.content,
                showAllText: item.showAllText,
                isReplySheet: true
            )
            cell.delegate = self
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ReplySection, CommentItem>()
        snapshot.appendSections([.comment, .replies])
        let commentItem = CommentItem(entity: viewModel.getCommentContent(), showAllText: false)
        snapshot.appendItems([commentItem], toSection: .comment)
        
        let replyItems = viewModel.getReplyList().map { CommentItem(entity: $0, showAllText: false) }
        snapshot.appendItems(replyItems, toSection: .replies)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc
    private func backButtonDidTap() {
        self.dismiss(animated: true)
    }
}

extension CommonQuestReplyViewController: CommentProtocol {
    func menuButtonDidTap(commentID: Int, isMyComment: Bool) {
        let commonQuestBottomSheet = ViewControllerFactory.shared.makeCommonQuestBottomSheetViewController()
        
        commonQuestBottomSheet.configure(
            sheeetType: isMyComment ? .myComment : .otherComment ,
            targetID: commentID
        )
        
        commonQuestBottomSheet.presentBottomSheet(commonQuestBottomSheet, height: 224.adjustedH)
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

extension CommonQuestReplyViewController: KeyboardHandleProtocol  {
    func keyboardWillShowOrHide(height: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration) {
            self.rootView.updateLayout(keyboardHeight: height)
            self.rootView.layoutIfNeeded()
        }
    }
}
