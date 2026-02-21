//
//  WriteQuestionTypeViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/8/25.
//

import Combine
import UIKit

import Mixpanel

final class WriteQuestionTypeQuestViewController: BaseViewController {
    
    private let rootView = WriteQuestionTypeQuestView()
    private let viewModel: WriteQuestionTypeViewModel
    private var cancellables = Set<AnyCancellable>()
    var questMode: QuestMode = .write
    
    private var questID: Int = 1
    private var questNumber: Int = 1
    private var questType: QuestType = .activation
    
    private var answerText: String = ""
    private var emotionState: String = ""
    private var isKeyboardUsed: Bool = false
    
    private let bottomSheetViewController = EmotionBottomSheetViewController()
    
    init(viewModel: WriteQuestionTypeViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        isKeyboardUsed = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .back(header: .black),
            action: #selector(back)
        )
        
        bind()
        setDelegate()
        
        if questMode == .write {
            viewModel.action(.viewDidLoad(quesetID: self.questID))
        }
        
        let property = QuestEvents.QuestWriteStartProperty(
            questStartAt: Date().toString(),
            questNumber: questNumber,
            questType: questType.mixpanelKey
        )
        Mixpanel.mainInstance().track(
            event: QuestEvents.Name.questWritePageView,
            properties: property.dictionary
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func setAddTarget() {
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
        
        let tipTagGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tipTagDidTap))
        self.rootView.title.tipTag.addGestureRecognizer(tipTagGestureRecognizer)
        self.rootView.title.tipTag.isUserInteractionEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func setDelegate() {
        rootView.questTextField.delegate = self
    }
}

extension WriteQuestionTypeQuestViewController {
    @objc
    private func textViewMoveUp(_ notification: NSNotification) {
        if self.view.window?.frame.origin.y == 0 && !isKeyboardUsed{
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                let safeAreaBottom = view.safeAreaInsets.bottom
                let offsetY = keyboardHeight - safeAreaBottom
                
                UIView.animate(withDuration: 0.3) {
                    self.rootView.transform = CGAffineTransform(translationX: 0, y: -offsetY * 0.5)
                }
                
                isKeyboardUsed = true
            }
        }
    }
    
    @objc
    private func textViewMoveDown(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.rootView.transform = .identity
        }
        isKeyboardUsed = false
    }
    
    @objc
    private func confirmButtonDidTap() {
        answerText = rootView.questTextField.textView.text
        
        if questMode == .edit {
            saveQuest()
        } else {
            bottomSheetViewController.bind(questNumber: questNumber, questType: questType)
            bottomSheetViewController.delegate = self
            if let sheet = bottomSheetViewController.sheetPresentationController{
                sheet.detents = [.custom { _ in 471.adjustedH }]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.preferredCornerRadius = 8
            }
            self.present(bottomSheetViewController, animated: true)
        }
        
        let property = QuestEvents.QuestWriteFinishProperty(
            questLength: rootView.questTextField.textView.text.count,
            questNumber: questNumber,
            questType: questType.mixpanelKey
        )
        Mixpanel.mainInstance().track(
            event: QuestEvents.Name.questWriteSuccess,
            properties: property.dictionary
        )
    }
    
    @objc
    private func tipTagDidTap() {
        let viewController = ViewControllerFactory.shared.makeQuestTipViewController()
        viewController.bind(questID: questID, questType: questType, questNumber: questNumber)
        viewController.navigationItem.hidesBackButton = true
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false)
    }
}

extension WriteQuestionTypeQuestViewController: ToastPresentable, ToastErrorHandler {
    
    private func bind() {
        viewModel.output.questInfoResultPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let quest):
                    self?.questNumber = quest.questNumber
                    self?.rootView.updateQuestTitle(
                        step: quest.step,
                        stepNum: quest.stepNumber,
                        questNumber: quest.questNumber,
                        questStyle: quest.questStyle,
                        question: quest.question
                    )
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.didSuccessPostPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(()):
                    guard let self else { return }
                    self.bottomSheetViewController.dismiss(animated: true) {
                        let modal = ModalBuilder(
                            modalView: QuestCompleteModal(),
                            action: nil,
                            rootViewController: self
                        )
                        modal.present()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            modal.dismiss()
                            
                            ByeBooLogger.debug("퀘스트 아이디 \(self.questID)")
                            let viewController = ViewControllerFactory.shared.makeArchiveQuestViewController()
                            viewController.entryViewController = .writeQuest
                            viewController.configure(questID: self.questID, questType: .question)
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.didSuccessEditPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(()):
                    guard let self else { return }
                    let viewController = ViewControllerFactory.shared.makeArchiveQuestViewController()
                    viewController.entryViewController = .edit
                    viewController.configure(questID: self.questID, questType: .question)
                    self.navigationController?.pushFromLeftToRight(viewController)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.isValidTextPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case true:
                    self?.rootView.confirmButton.updateType(.enabled)
                case false:
                    self?.rootView.confirmButton.updateType(.disabled)
                }
            }
            .store(in: &cancellables)
    }
}

extension WriteQuestionTypeQuestViewController: BackNavigable {
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
}

extension WriteQuestionTypeQuestViewController: BottomSheetProtocol {
    func saveEmotionState(emotionState: ByeBooEmotion) {
        self.emotionState = emotionState.key
    }
    
    func saveQuest() {
        ByeBooLogger.debug("text: \(answerText)")
        ByeBooLogger.debug("emtionState: \(emotionState)")
        ByeBooLogger.debug("questID: \(questID)")
        
        viewModel.action(.presentCompleteView(
            questID: questID,
            answer: answerText,
            emotionState: emotionState,
            isEdit: questMode == .edit ? true : false
        )
        )
    }
}

extension WriteQuestionTypeQuestViewController {
    func configure(_ questID: Int, _ questNumber: Int, _ questType: QuestType) {
        self.questID = questID
        self.questNumber = questNumber
        self.questType = questType
    }
}

extension WriteQuestionTypeQuestViewController: EditQuestProtocol {
    func getExistingQuest(questID: Int, questAnswer: String?, image: String?, imageKey: String?) {
        self.questID = questID
        self.viewModel.action(.viewDidLoadWhenEditMode(questID: questID))
        guard let questAnswer = questAnswer else { return }
        self.answerText = questAnswer
        rootView.questTextField.textView.text = questAnswer
        
        let textCount = questAnswer.count
        rootView.questTextField.textCount.text = "(\(textCount)/\(rootView.questTextField.limitCount))"
        rootView.questTextField.isPlaceholderActive = false
        rootView.confirmButton.updateType(.disabled)
    }
}

extension WriteQuestionTypeQuestViewController: QuestCompleteProtocol {
    func updateButtonWhenWriting(text: String) {
        viewModel.action(.textFieldEditing(answerText: self.answerText, text: text))
    }
}
