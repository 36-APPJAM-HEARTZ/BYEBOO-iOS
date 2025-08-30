//
//  ToastPresentable.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/30/25.
//

import UIKit

protocol ToastPresentable: AnyObject {
    func presentToastMessage(type: ToastMessageType)
}

extension ToastPresentable where Self: BaseViewController {
    
    func presentToastMessage(type: ToastMessageType) {
        let toastMessageView = ToastMessageView(
            image: type.image,
            text: type.text
        )
        
        setUI(toastMessageView)
        setLayout(toastMessageView)
    }
    
    private func setUI(_ view: ToastMessageView) {
        self.view.addSubview(view)
    }
    
    private func setLayout(_ view: ToastMessageView) {
        view.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(104.adjustedH)
        }
    }
}
