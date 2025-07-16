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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGesture()
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
        
        modalView.actionButton.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        guard let cancelButton = modalView.dismissButton else { return }
        cancelButton.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
    }
}

extension CustomModalController: UIGestureRecognizerDelegate {
    @objc
    func actionButtonDidTap() {
        if let action {
            ByeBooLogger.debug("action button 터치")
            action()
            dismiss(animated: false)
        }
    }
    
    @objc
    func dismissButtonDidTap() {
        ByeBooLogger.debug("dismiss button 터치")
        dismiss(animated: false)
    }
    
    @objc
    func backgroundDidTap() {
        ByeBooLogger.debug("background 터치")
        dismiss(animated: false)
    }
    
    private func setGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap))
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        let location = touch.location(in: view)
        return !modalView.frame.contains(location)
    }
}
