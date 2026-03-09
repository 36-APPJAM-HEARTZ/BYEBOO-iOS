//
//  CommonQuestHistoryViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import UIKit

final class CommonQuestHistoryViewController: BaseViewController {
    
    private let rootView = CommonQuestHistoryView()
    private var commonQuestArchiveType: CommonQuestArchiveType = .mine
    private var writerID: Int = 0
    
    override func loadView() {
        view = rootView
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
    }
}

extension CommonQuestHistoryViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension CommonQuestHistoryViewController {
    
    @objc
    private func bottomUp() {
        let commonQuestBottomSheet = ViewControllerFactory.shared.makeCommonQuestBottomSheetViewController()
        commonQuestBottomSheet.configure(sheeetType: commonQuestArchiveType, writerID: writerID)
        commonQuestBottomSheet.delegate = self
        if let sheet =  commonQuestBottomSheet.sheetPresentationController{
            sheet.detents = [.custom { _ in 224.adjustedH }]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 8
        }
        self.present(commonQuestBottomSheet, animated: true)
    }
}

extension CommonQuestHistoryViewController {
    
    func configure(
        question: String,
        writtenAt: String,
        profileIcon: UIImage? = nil,
        nickname: String? = nil,
        content: String,
        writerID: Int? = nil
    ) {
        commonQuestArchiveType = nickname == nil ? .mine : .other
        
        if let writerID {
            self.writerID = writerID
        }
        
        rootView.configure(
            question: question,
            writtenAt: writtenAt,
            profileIcon: profileIcon,
            nickname: nickname,
            content: content
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
