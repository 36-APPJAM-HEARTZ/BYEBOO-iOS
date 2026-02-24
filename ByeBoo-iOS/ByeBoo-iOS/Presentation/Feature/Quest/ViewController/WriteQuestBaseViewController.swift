//
//  BaseWriteQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 2/24/26.
//

import UIKit

protocol WriteQuestBaseProtocol where Self: UIView {
    var scrollView: UIScrollView { get }
    var questTextView: UITextView { get }
    var questCountLabelView: UIView { get }
    var tipTagView: UIView { get }
}

class WriteQuestBaseViewController<RootView: BaseView & WriteQuestBaseProtocol>:
    BaseViewController, UIGestureRecognizerDelegate, BackNavigable {
    
    let rootView: RootView
    var isKeyboardUsed: Bool = false
    private var keyboardFrameInWindow: CGRect = .zero
    private var currentKeyboardOffset: CGFloat = 0
    private var previousTextViewHeight: CGFloat = 0
    
    
    init(rootView: RootView) {
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerKeyboardNotificationCenter()
        isKeyboardUsed = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .confirmAndBack("완료", header: .black),
            action: #selector(back),
            secondAction: #selector(confirmButtonDidTap)
        )
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifiationCneter()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeKeyboardNotifiationCneter()
    }
    
    override func setAddTarget() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditingOnTap))
        let tipTagGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tipTagDidTap))
        
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.cancelsTouchesInView = false
        
        rootView.scrollView.addGestureRecognizer(tapGestureRecognizer)
        rootView.tipTagView.addGestureRecognizer(tipTagGestureRecognizer)
        rootView.tipTagView.isUserInteractionEnabled = true
    }
    
    func back() {
        tabBarController?.tabBar.isHidden = true
        
        let action: (() -> Void) = {
            self.navigationController?.popViewController(animated: true)
            self.tabBarController?.tabBar.isHidden = false
        }
        
        ModalBuilder(
            modalView: QuitModalView(),
            action: action,
            rootViewController: self
        ).present()
    }
    
    @objc func tipTagDidTap() {}
    @objc func confirmButtonDidTap() { }
    
    @objc
    private func textViewMoveUp(_ notification: NSNotification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        keyboardFrameInWindow = keyboardFrame.cgRectValue
        currentKeyboardOffset = 0
        previousTextViewHeight = rootView.questTextView.bounds.height
        isKeyboardUsed = true
        
        DispatchQueue.main.async { [weak self] in
            self?.adjustViewForKeyboard(mode: .caretTracking)
        }
    }
    
    @objc
    private func textViewMoveDown(_ notification: NSNotification) {
        keyboardFrameInWindow = .zero
        currentKeyboardOffset = 0
        previousTextViewHeight = 0
        UIView.animate(withDuration: 0.3) {
            self.rootView.transform = .identity
        }
        isKeyboardUsed = false
    }
    
    @objc
    private func endEditingOnTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
}

extension WriteQuestBaseViewController {
    enum KeyboardAdjustMode {
        case textGrowth
        case caretTracking
    }
    
    func adjustViewForKeyboard(mode: KeyboardAdjustMode) {
        guard isKeyboardUsed else { return }
        guard !keyboardFrameInWindow.isEmpty else { return }
        
        switch mode {
        case .textGrowth:
            adjustViewForTextGrowth()
        case .caretTracking:
            adjustViewForCurrentCaret()
        }
    }
    
    private func adjustViewForTextGrowth() {
        let currentHeight = rootView.questTextView.bounds.height
        guard currentHeight > 0 else { return }
        
        if previousTextViewHeight == 0 {
            previousTextViewHeight = currentHeight
            return
        }
        
        let diff = currentHeight - previousTextViewHeight
        previousTextViewHeight = currentHeight
        
        guard abs(diff) > 0.5 else { return }
        
        let targetView = rootView.questCountLabelView
        let targetViewFrameInWindow = targetView.convert(targetView.bounds, to: nil)
        let overlap = keyboardOverlap(for: targetViewFrameInWindow)
        let targetOffset = max(0, currentKeyboardOffset + overlap)
        
        applyKeyboardOffset(targetOffset)
    }
    
    private func adjustViewForCurrentCaret() {
        let textView = rootView.questTextView
        guard textView.isFirstResponder,
              let selectedRange = textView.selectedTextRange else { return }
        
        let caretRect = textView.caretRect(for: selectedRange.end)
        let caretInWindow = textView.convert(caretRect, to: nil)
        let overlap = keyboardOverlap(for: caretInWindow)
        let targetOffset = max(0, overlap)
        
        applyKeyboardOffset(targetOffset)
    }
    
    private func keyboardOverlap(for rectInWindow: CGRect) -> CGFloat {
        let keyboardTop = keyboardFrameInWindow.minY
        let padding = 24.adjustedH
        return rectInWindow.maxY + padding - keyboardTop
    }
    
    private func applyKeyboardOffset(_ targetOffset: CGFloat) {
        guard abs(targetOffset - currentKeyboardOffset) > 0.5 else { return }
        currentKeyboardOffset = targetOffset
        
        UIView.animate(withDuration: 0.2) {
            self.rootView.transform = CGAffineTransform(translationX: 0, y: -self.currentKeyboardOffset)
        }
    }
}

extension WriteQuestBaseViewController {
    private func registerKeyboardNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textViewMoveUp),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textViewMoveDown),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    private func removeKeyboardNotifiationCneter() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
