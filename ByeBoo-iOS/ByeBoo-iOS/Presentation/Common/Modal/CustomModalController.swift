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
        
        // 디자인(375pt) 기준 폭 280 고정. 넓은 화면(펼친 iPhone Duo)에서 가로로 늘어나지 않도록 함
        // 좁은 화면에서는 좌우 여백 24를 남기고 줄어듦
        modalView.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(280).priority(.high)
            $0.width.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(24)
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
