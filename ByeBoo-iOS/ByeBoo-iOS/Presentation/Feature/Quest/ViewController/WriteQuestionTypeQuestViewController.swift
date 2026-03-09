//
//  WriteQuestionTypeViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/8/25.
//

import Combine
import UIKit

import Mixpanel

final class WriteQuestionTypeQuestViewController: WriteQuestBaseViewController<WriteQuestionTypeQuestView> {
    
    private let viewModel: WriteQuestionTypeViewModel
    private var cancellables = Set<AnyCancellable>()
    var questMode: QuestMode = .write
    var questScope: QuestScope = .personal
    
    private var questID: Int = 1
    private var questNumber: Int = 1
    private var questType: QuestType = .activation
    private var questTitle: String = ""
    
    private var answerText: String = ""
    private var emotionState: String = ""
    private var answerID: Int = 1
    private var writtenAt: String = ""
    
    private let bottomSheetViewController = EmotionBottomSheetViewController()
    
    init(viewModel: WriteQuestionTypeViewModel){
        self.viewModel = viewModel
        super.init(rootView: WriteQuestionTypeQuestView(questScope: questScope))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setDelegate()
        
        if questMode == .write && questScope == .personal {
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
    
    override func setDelegate() {
        rootView.questTextField.delegate = self
    }
    
    @objc
    override func tipTagDidTap() {
        let viewController = ViewControllerFactory.shared.makeQuestTipViewController()
        viewController.bind(questID: questID, questType: questType, questNumber: questNumber)
        viewController.navigationItem.hidesBackButton = true
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false)
    }
    
    @objc
    override func confirmButtonDidTap() {
        answerText = rootView.questTextField.textView.text
        
        switch questScope {
        case .common:
            let isEdit = questMode == .edit ? true : false
            saveQuest(isEdit: isEdit, isCommonQuest: true)
            ByeBooLogger.debug("common quest 완료")
            
        case .personal:
            if questMode == .edit {
                saveQuest(isEdit: true, isCommonQuest: false)
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
}


extension WriteQuestionTypeQuestViewController: ToastPresentable, ToastErrorHandler {
    
    private func bind() {
        viewModel.output.questInfoResultPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let quest):
                    self.questNumber = quest.questNumber
                    self.rootView.updateQuestTitle(
                        questScope: self.questScope,
                        questNumber: quest.questNumber,
                        question: quest.question
                    )
                case .failure(let error):
                    self.handleError(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.didSuccessPostPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(()):
                    guard let self else { return }
                    switch questScope {
                    case .personal:
                        personalQuestComplete()
                    case .common:
                        commonQuestComplete()
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
                guard let self else { return }
                switch result {
                case true:
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                case false:
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.isForbiddenWordPublisher
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    ByeBooLogger.debug("공통 퀘스트 비속어 없음")
                case .failure(let error):
                    presentToastMessage(type: .questViolation)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.didSucessUpdatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    if let viewControllers = self.navigationController?.viewControllers,
                       viewControllers.count >= 2 {
                        
                        let previousVC = viewControllers[viewControllers.count - 2]
                        
                        if let historyVC = previousVC as? CommonQuestHistoryViewController {
                            historyVC.configure(
                                question: questTitle,
                                writtenAt: writtenAt,
                                content: self.rootView.questTextField.textView.text
                            )
                        }
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self.handleError(error)
                }
            }
            .store(in: &cancellables)
    }
}

extension WriteQuestionTypeQuestViewController: BottomSheetProtocol {
    func saveEmotionState(emotionState: ByeBooEmotion) {
        self.emotionState = emotionState.key
    }
    
    func saveQuest(isEdit: Bool, isCommonQuest: Bool?) {
        ByeBooLogger.debug("text: \(answerText)")
        ByeBooLogger.debug("emtionState: \(emotionState)")
        ByeBooLogger.debug("questID: \(questID)")
        if let isCommonQuest = isCommonQuest {
            viewModel.action(.saveQuest(
                questID: questID,
                answer: answerText,
                emotionState: emotionState,
                isEdit: isEdit,
                isCommonQuest: isCommonQuest,
                answerID: answerID
            )
            )
        }
    }
}

extension WriteQuestionTypeQuestViewController {
    func configureToWrite(
        _ questID: Int,
        _ questNumber: Int?,
        _ questType: QuestType,
        _ questionTitle: String?
    ) {
        self.questID = questID
        setQuestInformation(questNumber, questType, questionTitle)
    }
    
    func configureToEdit(
        _ questNumber: Int?,
        _ questType: QuestType,
        _ questionTitle: String?,
        _ answerID: Int,
        _ answer: String,
        _ writtenAt: String
    ) {
        setQuestInformation(questNumber, questType, questionTitle)
        setQuestTextField(answer: answer)
        
        self.answerText = answer
        self.answerID = answerID
        self.questMode = .edit
        self.writtenAt = writtenAt
    }
    
    private func setQuestInformation(
        _ questNumber: Int?,
        _ questType: QuestType,
        _ questionTitle: String?
    ) {
        if let questNumber {
            questScope = .personal
            self.questNumber = questNumber
        } else {
            questScope = .common
        }
        
        self.questType = questType
        self.questTitle = questionTitle ?? ""
        rootView.updateQuestTitle(
            questScope: self.questScope,
            questNumber: self.questNumber,
            question: questionTitle ?? ""
        )
    }
    
    private func setQuestTextField(answer: String) {
        rootView.questTextField.do {
            $0.applyTextViewStyle(text: answer, color: .grayscale100)
            $0.isPlaceholderActive = false
            $0.textCountLabel.text = "(\(answer.count)/\(rootView.questTextField.limitCount))"
        }
    }
    
    private func personalQuestComplete() {
        ByeBooLogger.debug("퀘스트 아이디 \(self.questID)")
        
        bottomSheetViewController.dismiss(animated: true) {
            let archiveViewController = ViewControllerFactory.shared.makeArchiveQuestViewController()
            archiveViewController.entryViewController = .writeQuest
            archiveViewController.configure(questID: self.questID, questType: .question)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                let modal = ModalBuilder(
                    modalView: QuestCompleteModal(),
                    action: nil,
                    rootViewController: self
                )
                modal.present()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    modal.dismiss()
                }
            }
            self.navigationController?.pushViewController(archiveViewController, animated: true)
            CATransaction.commit()
        }
    }
    
    private func commonQuestComplete() {
        let viewController = ByeBooTabBar()
        viewController.selectedIndex = 1
        guard let questMaintab = viewController.viewControllers?[1] as? UINavigationController,
              let commonQuestTab = questMaintab.viewControllers.first as? ParentQuestViewController<QuestTabItem> else { return }
        
        commonQuestTab.loadViewIfNeeded()
        commonQuestTab.selectTab(index: 1)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            ViewControllerUtils.setRootViewController(
                window: window,
                viewController: viewController,
                withAnimation: true
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            let modal = ModalBuilder(
                modalView: QuestCompleteModal(),
                action: nil,
                rootViewController: viewController
            )
            modal.present()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                modal.dismiss()
            }
        }
    }
}

extension WriteQuestionTypeQuestViewController: EditQuestProtocol {
    func getExistingQuest(
        questID: Int,
        questAnswer: String?,
        image: String?,
        imageKey: String?
    ) {
        self.questID = questID
        self.viewModel.action(.viewDidLoadWhenEditMode(questID: questID))
        
        guard let questAnswer = questAnswer else {
            return
        }
        
        self.answerText = questAnswer
        setQuestTextField(answer: questAnswer)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

extension WriteQuestionTypeQuestViewController: QuestCompleteProtocol {
    func updateButtonWhenWriting(text: String) {
        viewModel.action(.textFieldEditing(answerText: self.answerText, text: text))
        if isKeyboardUsed {
            scrollCountLabelIfNeeded()
        }
    }
}
