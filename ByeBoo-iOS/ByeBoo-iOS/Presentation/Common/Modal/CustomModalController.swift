//
//  CustomModalController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/5/25.
//

import UIKit

final class CustomModalController: BaseViewController {
    private let modalView: UIView
    private let action: (() -> Void)?
    
    init(
        modalView: UIView,
        action: (() -> Void)? = nil
    ) {
        self.modalView = modalView
        self.action = action
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setView() {
        view.backgroundColor = .black80
        
        view.addSubview(modalView)
        
        modalView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func setAddTarget() {
        guard let modalView = modalView as? BaseModal else { return }
        
        modalView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
}

extension CustomModalController {
    @objc
    func confirmButtonTapped() {
        if let action {
            action()
        }
    }
}
