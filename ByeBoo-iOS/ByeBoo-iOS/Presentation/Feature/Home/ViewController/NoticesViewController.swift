//
//  NoticesViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 4/30/26.
//

import UIKit

final class NoticesViewController: BaseViewController {
    
    private let isExistNotice: Bool
    private let rootView = NoticesView()
    
    init(isExistNotice: Bool) {
        self.isExistNotice = isExistNotice
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
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .titleAndBack("알림"),
            action: #selector(back)
        )
                
        rootView.contentView.decideNoticeContent(isExistNotice: isExistNotice)
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

extension NoticesViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension NoticesViewController {
    
    @objc
    private func readAllButtonDidTap() {}
}

extension NoticesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 실제로는 알림 개수만큼 설정
        2
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeCardCell.identifier, for: indexPath) as? NoticeCardCell
        else {
            return UITableViewCell()
        }

        return cell
    }
}

extension NoticesViewController: UITableViewDelegate {
    
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
