//
//  KeyboardHandlable+.swift
//  ByeBoo-iOS
//

import UIKit

protocol KeyboardHandleProtocol where Self: UIViewController {
    func keyboardWillShowOrHide(height: CGFloat, duration: Double)
}

extension KeyboardHandleProtocol {
    func keyboardWillShowOrHide(duration: Double) {
        keyboardWillShowOrHide(height: 0, duration: duration)
    }
}

extension KeyboardHandleProtocol {
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                  let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else { return }
            self?.keyboardWillShowOrHide(height: keyboardFrame.height, duration: duration)
        }

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else { return }
            self?.keyboardWillShowOrHide(duration: duration)
        }
    }

    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
