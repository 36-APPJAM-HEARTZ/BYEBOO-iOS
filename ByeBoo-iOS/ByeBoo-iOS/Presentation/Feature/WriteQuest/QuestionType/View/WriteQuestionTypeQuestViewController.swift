//
//  WriteQuestionTypeViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/8/25.
//

import UIKit

final class WriteQuestionTypeQuestViewController: BaseViewController {
    
    private let rootView = WriteQuestionTypeQuestView()
    
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
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tipTagDidTap))
//        rootView.title.tipTag.addGestureRecognizer(tap)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension WriteQuestionTypeQuestViewController {
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
    private func confirmButtonDidTap() {
        let viewController = EmotionBottomSheetViewController()
        viewController.previousView = .question
        viewController.delegate = self
        if let sheet = viewController.sheetPresentationController{
            sheet.detents = [.custom { _ in 515.adjustedH }]
            sheet.prefersGrabberVisible = false
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 8
        }
        self.present(viewController, animated: true)
    }
    
// TODO: Quest Tip View 머지 후 주석 해제
//    @objc
//    private func tipTagDidTap() {
//        let viewController = QuestTipViewController()
//        self.navigationController?.pushViewController(viewController, animated: true)
//    }
}

extension WriteQuestionTypeQuestViewController: BackNavigable {
    func back() {
        ModalBuilder(
            modalView: QuitModalView(),
            action: {
                ByeBooLogger.debug("모달 뜸")
                // TODO: 퀘스트 조회 뷰로 연결
            },
            rootViewController: self
        ).present()
    }
}

extension WriteQuestionTypeQuestViewController: TipTagDidTapProtocol {
    func tipTagDidTap() {
        let viewController = QuestTipViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension WriteQuestionTypeQuestViewController: BottomSheetProtocol {
    func presentNextViewController(from previousView: PreviousView) {
        let viewController = CompleteQuestionTypeQuestViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
