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
        guard let tappedView = tapRecognizer.view else { return }
        
        switch tappedView.tag {
        case 0:
            if sheetType == .mine {
                // TODO: 수정하기
            } else {
                // TODO: 차단하기
            }
        case 1:
            if sheetType == .mine {
                // TODO: 삭제하기
            } else {
                // TODO: 신고하기
            }
        default:
            break
        }
        
    }
    
    @objc
    private func dismissButtonDidTap() {
        presentingViewController?.dismiss(animated: true)
    }
}
