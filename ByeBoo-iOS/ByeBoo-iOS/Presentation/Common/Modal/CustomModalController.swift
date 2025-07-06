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
            $0.horizontalEdges.equalToSuperview().inset(47.5.adjustedW)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setAddTarget() {
        guard let modalView = modalView as? ModalProtocol else { return }
        
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
    
    @objc
    func cancelButtonTapped() {
        dismiss(animated: false)
    }
}
