//
//  BaseWriteQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 2/24/26.
//

import UIKit

import SnapKit

protocol WriteQuestBaseProtocol where Self: UIView {
    var scrollView: UIScrollView { get }
    var questTextView: QuestTextField { get }
    var questCountLabelView: UILabel { get }
    var tipTagView: UIView { get }
    var bottomView: UIView { get }
}

protocol WriteQuestTextViewProtocol: AnyObject {
    func textViewDidBeginEditing()
    func textViewDidEndEditing()
    func textViewDidChange(count: Int)
}

protocol UpdateUIWhenKeyboardProtocol: AnyObject {
    func updateUIWhenKeyboardUp()
    func updateUIWhenKeyboardDown()
    func updateBottomConstraint(_ offset: CGFloat)
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
    private func keyboardWillUp(_ notification: NSNotification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curveRaw = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
                else { return }

        keyboardFrameInWindow = frame
        scrollCountLabelIfNeeded()
        applyKeyboardInset()

        let curve = UIView.AnimationOptions(rawValue: curveRaw << 16)
        let keyboardHeight = max(0, view.bounds.height - frame.origin.y)

        if let rootView = rootView as? UpdateUIWhenKeyboardProtocol {
            if keyboardHeight > 0 {
                rootView.updateUIWhenKeyboardUp()
                rootView.updateBottomConstraint(-keyboardHeight)
            }
            else {
                rootView.updateUIWhenKeyboardDown()
            }
            
        }
        UIView.animate(withDuration: duration, delay: 0, options: curve) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @objc
    private func keyboardWillDown(_ notification: NSNotification) {
        keyboardFrameInWindow = .zero
        currentKeyboardOffset = 0
        UIView.animate(withDuration: 0.3) {
            self.rootView.scrollView.contentInset.bottom = 0
        }
        isKeyboardUsed = false
    }
    
    @objc
    private func endEditingOnTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
}

extension WriteQuestBaseViewController {
    func applyTextViewGrowth() {
        let diff = rootView.questTextView.updateTextViewHeight()
        
        guard diff > 0.5 else { return }
        
        var offset = rootView.scrollView.contentOffset
        offset.y += diff
        let bottomContainerHeight = rootView.bottomView.frame.height
        let maxOffsetY = rootView.scrollView.contentSize.height
            - rootView.scrollView.bounds.height
        + rootView.scrollView.contentInset.bottom
        + bottomContainerHeight
        
        offset.y = min(offset.y, max(0, maxOffsetY))
        rootView.scrollView.setContentOffset(offset, animated: false)
    }
    
    private func scrollCountLabelIfNeeded() {
        let targetFrameInWindow = rootView.questCountLabelView.convert(rootView.questCountLabelView.bounds, to: nil)
        let overlap = keyboardOverlap(for: targetFrameInWindow)
        guard overlap > 0 else { return }

        let targetFrameInScroll = rootView.questCountLabelView.convert(
            rootView.questCountLabelView.bounds,
            to: rootView.scrollView
        )
        
        let bottomContainerHeight = rootView.bottomView.frame.height
        let labelBottom = targetFrameInScroll.maxY
        let visibleHeight = rootView.scrollView.frame.height
        let padding: CGFloat = 200.adjustedH

        let targetOffsetY = labelBottom - visibleHeight + bottomContainerHeight + padding

        guard targetOffsetY > rootView.scrollView.contentOffset.y else { return }

        rootView.scrollView.setContentOffset(
            CGPoint(x: 0, y: targetOffsetY),
            animated: true
        )
    }

    private func keyboardOverlap(for rectInWindow: CGRect) -> CGFloat {
        let keyboardTop = keyboardFrameInWindow.minY
        let padding = 24.adjustedH
        return rectInWindow.maxY + padding - keyboardTop
    }
    
    private func applyKeyboardInset() {
        let keyboardFrameInView = view.convert(keyboardFrameInWindow, from: nil)
        let overlap = view.bounds.intersection(keyboardFrameInView).height
        let targetOffset = max(0, overlap - view.safeAreaInsets.bottom)
        
        guard abs(targetOffset - currentKeyboardOffset) > 0.5 else { return }
        currentKeyboardOffset = targetOffset
        
        UIView.animate(withDuration: 0.2) {
            self.rootView.scrollView.contentInset.bottom = self.currentKeyboardOffset
        }
    }
}

extension WriteQuestBaseViewController {
    private func registerKeyboardNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillUp),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDown),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    private func removeKeyboardNotifiationCneter() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
