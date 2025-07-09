//
//  WriteQuestionTypeViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/8/25.
//

import UIKit

final class WriteQuestionTypeQuestViewController: BaseViewController {
    
    private let rootView = WriteQuestionTypeQuestView()
    private let tipViewModel = QuestTipViewModel()
    
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
    }
    
    override func setAddTarget() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTapped), for: .touchUpInside)
        rootView.title.tipTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tipTagDidTap)))
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
            })
        }
    }
    
    @objc
    private func textViewMoveDown() {
        self.rootView.transform = .identity
    }
    
    @objc
    private func confirmButtonDidTapped() {
        
    }
}

extension WriteQuestionTypeQuestViewController: BackNavigable {
    func back() {
        
    }
}

extension WriteQuestionTypeQuestViewController: TipTagDidTapProtocol {
    func tipTagDidTap() {
        tipViewModel.action(.tagButtonDidTap)
        let vc = QuestTipViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
