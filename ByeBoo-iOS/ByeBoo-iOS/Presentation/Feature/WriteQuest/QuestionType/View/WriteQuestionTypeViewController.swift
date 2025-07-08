//
//  WriteQuestionTypeViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/8/25.
//

import UIKit

final class WriteQuestionTypeViewController: BaseViewController {
    
    private let rootView = WriteQuestionTypeView()
    
    override func loadView() {
        view = rootView
    }
    
    override func setAddTarget() {
        print("등록")
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func textViewMoveUp(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                let offsetY = keyboardSize.height - self.rootView.safeAreaInsets.bottom * 4
                self.rootView.transform = CGAffineTransform(translationX: 0, y: -offsetY)
                print("keyboard height: \(keyboardSize.height)")
            })
        }
    }
    
    @objc
    private func textViewMoveDown() {
        self.rootView.transform = .identity
    }
}
