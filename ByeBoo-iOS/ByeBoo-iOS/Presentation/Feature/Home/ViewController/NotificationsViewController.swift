//
//  NotificationsViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 4/30/26.
//

import Combine
import UIKit

final class NotificationsViewController: BaseViewController {
    
    private let rootView = NoticesView()
    private let viewModel: NotificationsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: NotificationsViewModel) {
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
        
        viewModel.action(.viewWillAppear)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .titleAndBack("알림"),
            action: #selector(back)
        )
                
        bind()
    }
    
    override func setAddTarget() {
        rootView.readAllButton.addTarget(
            self,
            action: #selector(readAllButtonDidTap),
            for: .touchUpInside
        )
    }
    
    override func setDelegate() {
        rootView.contentView.noticeCardsView.cardTableView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(NoticeCardCell.self)
        }
    }
}

extension NotificationsViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension NotificationsViewController {
    
    @objc
    private func readAllButtonDidTap() {}
}

extension NotificationsViewController {
    
    func bind() {
        viewModel.output.notificationListResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let notificationList):
                    self?.rootView.contentView.decideNoticeContent(isExistNotice: !notificationList.notifications.isEmpty)
                    self?.rootView.contentView.noticeCardsView.cardTableView.reloadData()
                case .failure(let error):
                    ByeBooLogger.error(error)
                }
            }
            .store(in: &cancellables)
    }
}

extension NotificationsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.notificationList?.notifications.count ?? 0
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
        
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: NoticeCardCell.identifier,
                for: indexPath
            ) as? NoticeCardCell,
            let notification = viewModel.notificationList?.notifications[indexPath.section],
            let notificationType = notification.notificationType
        else {
            return UITableViewCell()
        }
        
        cell.bind(
            isRead: notification.isRead,
            notificationType: notificationType,
            title: notification.title,
            subtitle: notification.content,
            writtenTime: ""
        )
        
        return cell
    }
}

extension NotificationsViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        viewModel.action(.notificationDidTap(at: indexPath.section))
        viewModel.move(from: self, at: indexPath.section)
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        UIView()
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        0
    }
}
