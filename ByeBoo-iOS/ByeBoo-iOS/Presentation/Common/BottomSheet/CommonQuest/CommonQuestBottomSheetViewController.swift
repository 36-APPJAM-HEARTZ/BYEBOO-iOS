//
//  CommonQuestBottomSheetViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 2/23/26.
//

import UIKit

final class CommonQuestBottomSheetViewController: BaseViewController {
    private var rootView = CommonQuestBottomSheetView(sheetType: .other)
    var sheetType: CommonQuestArchiveType?
    
    override func loadView() {
        view = rootView
    }
    
    override func setAddTarget() {
        rootView.dismissButton.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
        rootView.itemList.enumerated().forEach { index, item in
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(sheetItemDidTap(_:)))
            item.tag = index
            item.addGestureRecognizer(tapRecognizer)
            item.isUserInteractionEnabled = true
        }
    }
    
    
    func configure(sheeetTYpe: CommonQuestArchiveType) {
        self.sheetType = sheeetTYpe
        if let sheetType {
            rootView = CommonQuestBottomSheetView(sheetType: sheetType)
        }
    }
    
    @objc
    private func sheetItemDidTap(_ tapRecognizer: UITapGestureRecognizer) {
        guard let tappedView = tapRecognizer.view,
        let sheetType = sheetType else { return }
        
        let index = tappedView.tag
        guard sheetType.items.indices.contains(index) else { return }
        
        let action = sheetType.items[index].action
        
        switch action {
        case .edit:
            // TODO: 수정하기
            ByeBooLogger.debug("edit")
        case .delete:
            // TODO: 삭제하기
            ByeBooLogger.debug("delete")
        case .block:
            // TODO: 차단하기
            ByeBooLogger.debug("block")
        case .report:
            // TODO: 신고하기
            ByeBooLogger.debug("report")
        }
    }
    
    @objc
    private func dismissButtonDidTap() {
        presentingViewController?.dismiss(animated: true)
    }
}
