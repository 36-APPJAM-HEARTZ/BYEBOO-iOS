//
//  ModalBuilder.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/6/25.
//

import UIKit

struct ModalBuilder {
    private let modalView: UIView
    private let action: (() -> Void)?
    
    private var modalViewController: UIViewController
    private var rootViewController: UIViewController
    
    init(
        modalView: UIView,
        action: (() -> Void)?,
        rootViewController: UIViewController
    ) {
        self.rootViewController = rootViewController
        self.modalView = modalView
        self.action = action
        self.modalViewController = CustomModalController(
            modalView: self.modalView,
            action: action
        )
    }
    
    func present() {
        modalViewController.modalPresentationStyle = .overFullScreen
        rootViewController.present(modalViewController, animated: false)
    }
}
