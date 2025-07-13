//
//  HomeViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/5/25.
//

import UIKit

import SnapKit
import Then

final class HomeViewController: BaseViewController {
    private let rootView = HomeView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGesture()
    }
    
    private func setGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headerDidTap))
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.cancelsTouchesInView = false
        rootView.headerView.homeStateView.addGestureRecognizer(tapGestureRecognizer)
    }
}

extension HomeViewController {
    @objc
    private func headerDidTap() {
        // 최초 여정 상태 변경 api 호출
        // 네비게이션
        let viewController = QuestStartViewController()
        viewController.hidesBottomBarWhenPushed = true
        viewController.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(viewController, animated: false)
        
        // 퀘스트 탭으로 변경
//        navigationController?.tabBarController?.selectedIndex = 1
    }
}

extension HomeViewController {
    private func updateCharacterMessage() {
        
    }
}
