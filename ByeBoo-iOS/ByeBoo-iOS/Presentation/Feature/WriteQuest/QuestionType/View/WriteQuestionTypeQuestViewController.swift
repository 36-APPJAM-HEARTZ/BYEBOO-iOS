//
//  WriteQuestionTypeViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/8/25.
//

import Combine
import UIKit

final class WriteQuestionTypeQuestViewController: BaseViewController {
    
    private let rootView = WriteQuestionTypeQuestView()
    private let viewModel: WriteQuestionTypeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var questID: Int
    private var answerText: String = ""
    private var emotionState: String = ""
    
    init(
        viewModel: WriteQuestionTypeViewModel,
        questID: Int
    ){
        self.viewModel = viewModel
        self.questID = questID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        bind()
        viewModel.action(.viewDidLoad(quesetID: questID))
    }
    
    override func setAddTarget() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
        
        let tipTagGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tipTagDidTap))
        self.rootView.title.tipTag.addGestureRecognizer(tipTagGestureRecognizer)
        self.rootView.title.tipTag.isUserInteractionEnabled = true
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
        answerText = rootView.questTextField.textView.text
        let viewController = EmotionBottomSheetViewController()
        viewController.delegate = self
        if let sheet = viewController.sheetPresentationController{
            sheet.detents = [.custom { _ in 515.adjustedH }]
            sheet.prefersGrabberVisible = false
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 8
        }
        self.present(viewController, animated: true)
    }
    
    @objc
    private func tipTagDidTap() {
        guard let viewModel = DIContainer.shared.resolve(type: QuestTipViewModel.self) else {
            return
        }
        let viewController = QuestTipViewController(viewModel: viewModel)
        viewController.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    private func bind() {
        viewModel.output.questInfoResultPublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success(let quest):
                    self.rootView.updateQuestTitle(
                        step: quest.step,
                        stepNum: quest.stepNumber,
                        questNumber: quest.questNumber,
                        questStyle: quest.questStyle,
                        question: quest.question
                    )
                case .failure(let failure):
                    ByeBooLogger.error(failure)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.didSuccessPostPublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success(()):
                    guard let viewModel = DIContainer.shared.resolve(type: CompleteQuestViewModel.self) else {
                        ByeBooLogger.error(ByeBooError.DIFailedError)
                        fatalError()
                    }
                    
                    let viewController = CompleteQuestionTypeQuestViewController(
                        viewModel: viewModel,
                        questID: self.questID
                    )
                    self.navigationController?.pushViewController(viewController, animated: true)
                case .failure(let failure):
                    ByeBooLogger.error(failure)
                }
            }
            .store(in: &cancellables)
    }
}

extension WriteQuestionTypeQuestViewController: BackNavigable {
    func back() {
        let action: (() -> Void) = { self.navigationController?.popViewController(animated: true) }
        
        ModalBuilder(
            modalView: QuitModalView(),
            action: action,
            rootViewController: self
        ).present()
    }
}

extension WriteQuestionTypeQuestViewController: BottomSheetProtocol {
    func saveEmotionState(emotionState: ByeBooEmotion) {
        self.emotionState = emotionState.key
    }
    
    func saveQuest() {
        ByeBooLogger.debug("text: \(answerText)")
        ByeBooLogger.debug("emtionState: \(emotionState)")

        self.viewModel.action(.presentCompleteView(
            questID: self.questID,
            answer: self.answerText,
            emotionState: self.emotionState
            )
        )
    }
}
