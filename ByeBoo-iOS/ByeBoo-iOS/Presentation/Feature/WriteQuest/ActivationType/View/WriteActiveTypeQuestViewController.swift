//
//  WriteActiveTypeQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import UIKit

final class WriteActiveTypeQuestViewController: BaseViewController {
    
    private let rootView = WriteActiveTypeQuestView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .back,
            action: #selector(back)
        )
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditingOnTap))
        ByeBooLogger.debug(tapGestureRecognizer)
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.cancelsTouchesInView = false
        self.rootView.scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func setAddTarget() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTapped), for: .touchUpInside)
    }
    
    @objc
    private func textViewMoveUp(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                let offsetY = keyboardSize.height
                self.rootView.transform = CGAffineTransform(translationX: 0, y: -offsetY)
            })
        }
    }
    
    @objc
    private func textViewMoveDown() {
        self.view.transform = .identity
    }
    
    @objc
    private func confirmButtonDidTapped() {
        
    }
    
    @objc
    private func endEditingOnTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
}

extension WriteActiveTypeQuestViewController: BackNavigable {
    func back() {
        
    }
}

extension WriteActiveTypeQuestViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view is UITextView || touch.view is UITextField) {
            return false
        }
        return true
    }
}
