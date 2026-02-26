//
//  BlockedkUserListViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/22/26.
//

import UIKit

final class BlockedkUserListViewController: BaseViewController {
    
    private let rootView = BlockedUserListView()
    private let viewModel: BlockedUserListViewModel
    
    init(viewModel: BlockedUserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getBlockedUsers()
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .titleAndBack("차단 사용자 목록", header: .black),
            action: #selector(back)
        )
    }
    
    override func setDelegate() {
        rootView.userTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(
                BlockedUserCell.self,
                forCellReuseIdentifier: BlockedUserCell.identifier
            )
        }
    }
}

extension BlockedkUserListViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension BlockedkUserListViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        0
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}

extension BlockedkUserListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.blockedUsersCount
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        // TO-DO : extension 메서드로 수정
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BlockedUserCell.identifier,
            for: indexPath
        ) as? BlockedUserCell else {
            return UITableViewCell()
        }
        
        guard let userName = viewModel.getBlockedUserName(at: indexPath.section) else {
            return UITableViewCell()
        }
        
        cell.bind(userName: userName)
        cell.clearButton.addTarget(
            self,
            action: #selector(clearButtonDidTap),
            for: .touchUpInside
        )
        return cell
    }
    
    @objc
    private func clearButtonDidTap() {
        let dismissButton = ByeBooButton(
            titleText: "아니오",
            type: .outline
        )
        let actionButton = ByeBooButton(
            titleText: "예",
            type: .enabled
        )
        let modal = ConfirmModalView(
            modalType: .block,
            dismissButton: dismissButton,
            actionButton: actionButton
        )
        let action: (() -> Void) = {}
        
        ModalBuilder(
            modalView: modal,
            action: action,
            rootViewController: self
        ).present()
    }
}
