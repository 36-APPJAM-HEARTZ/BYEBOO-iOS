//
//  WriteActiveTypeQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import Combine
import UIKit

import Kingfisher
import Mixpanel

final class WriteActiveTypeQuestViewController: BaseViewController {
    
    private let rootView = WriteActiveTypeQuestView()
    private let viewModel: WriteActiveTypeViewModel
    private var cancellables = Set<AnyCancellable>()
    var questMode: QuestMode = .write
    
    private var questID: Int = 31
    private var questType: QuestType = .activation
    private var questNumber: Int = 1
    
    private var answerText: String = ""
    private var emotionState: String = ""
    private var image: UIImage = UIImage()
    private var isKeyboardUsed: Bool = false
    private var isImageChanged: Bool = false
    private var originalImageKey: String = ""
    
    private let bottomSheetViewController = EmotionBottomSheetViewController()
    
    override func loadView() {
        view = rootView
    }
    
    init(viewModel: WriteActiveTypeViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        setGesture()
        setDelegate()
        bind()
        presentPhotoPicker()
        
        if questMode == .write {
            viewModel.action(.viewDidLoad(quesetID: questID))
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
    }
    
    override func setDelegate() {
        rootView.questTextField.delegate = self
    }
    
    private func setGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditingOnTap))
        let tipTagGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tipTagDidTap))
        
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.cancelsTouchesInView = false
        
        
        tipTagGestureRecognizer.isEnabled = true
        
        self.rootView.title.tipTag.addGestureRecognizer(tipTagGestureRecognizer)
        self.rootView.scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func presentPhotoPicker() {
        rootView.imageContainer.didTapAddImage = { [weak self] in
            guard let self = self else { return }
            self.openPhotosButtenPressed()
        }
    }
}

extension WriteActiveTypeQuestViewController {
    @objc
    private func textViewMoveUp(_ notification: NSNotification) {
        if self.view.window?.frame.origin.y == 0 && !isKeyboardUsed{
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                let safeAreaBottom = view.safeAreaInsets.bottom
                let offsetY = keyboardHeight - safeAreaBottom
                
                UIView.animate(withDuration: 0.3) {
                    self.rootView.transform = CGAffineTransform(translationX: 0, y: -offsetY)
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
        if rootView.questTextField.textView.text == rootView.questTextField.placeholder ||
            rootView.questTextField.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            answerText = ""
        } else {
            answerText = rootView.questTextField.textView.text
        }
        
        if questMode == .edit {
            saveQuest()
        } else {
            ByeBooLogger.debug(questID)
            bottomSheetViewController.bind(questNumber: questID, questType: questType)
            bottomSheetViewController.delegate = self
            if let sheet =  bottomSheetViewController.sheetPresentationController{
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
    private func endEditingOnTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
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

extension WriteActiveTypeQuestViewController: ToastPresentable, ToastErrorHandler {
    
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
                            viewController.configure(questID: self.questID, questType: .activation)
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.questInfoWhenEditModeResultPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let quest):
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
        
        viewModel.output.didSuccessEditPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(()):
                    guard let self else { return }
                    ByeBooLogger.debug("퀘스트 아이디 \(self.questID)")
                    let viewController = ViewControllerFactory.shared.makeArchiveQuestViewController()
                    viewController.entryViewController = .edit
                    viewController.configure(questID: self.questID, questType: .activation)
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

extension WriteActiveTypeQuestViewController: BackNavigable {
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

extension WriteActiveTypeQuestViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ agestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch)
    -> Bool {
        return true
    }
}

extension WriteActiveTypeQuestViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openPhotosButtenPressed() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            ByeBooLogger.debug(image)
            rootView.imageContainer.selectedImageView.image = image
            rootView.imageContainer.changeIconHidden()
            rootView.imgCount = 1
            rootView.updateImageCountLabel(count: rootView.imgCount)
            changeCount(count: rootView.imgCount)
            self.image = image
            isImageChanged = questMode == .edit ? true : false
        }
        dismiss(animated: true, completion: nil)
    }
}

extension WriteActiveTypeQuestViewController: BottomSheetProtocol {
    func saveEmotionState(emotionState: ByeBooEmotion) {
        self.emotionState = emotionState.key
    }
    
    func saveQuest() {
        var finalImageKey: String = ""
        
        if questMode == .edit && isImageChanged {
            finalImageKey = UUID().uuidString
        } else if questMode == .write {
            originalImageKey = UUID().uuidString
        }
        
        ByeBooLogger.debug("퀘스트 아이디 \(questID)")
        ByeBooLogger.debug("텍스트 \(answerText)")
        ByeBooLogger.debug("원래 이미지 키 \(originalImageKey)")
        ByeBooLogger.debug("수정된 이미지 키 \(finalImageKey)")
        
        self.viewModel.action(.didTapCompleteButton(
            questID: self.questID,
            answer: self.answerText,
            emotionState: self.emotionState,
            image: self.image,
            imageKey: finalImageKey.isEmpty ? originalImageKey : finalImageKey,
            isEdit: questMode == .edit ? true : false,
            isImageChanged: isImageChanged
        )
        )
    }
}

extension WriteActiveTypeQuestViewController {
    func configure(_ questID: Int, _ questNumber: Int, _ questType: QuestType) {
        self.questID = questID
        self.questNumber = questNumber
        self.questType = questType
    }
}

extension WriteActiveTypeQuestViewController: EditQuestProtocol {
    func getExistingQuest(questID: Int, questAnswer: String?, image: String?, imageKey: String?) {
        self.questID = questID
        self.viewModel.action(.navigateFromArchiveViewController(questID: questID))
        guard let questAnswer = questAnswer, let image = image, let imageKey = imageKey else { return }
        self.originalImageKey = imageKey
        self.answerText = questAnswer
        rootView.imageContainer.selectedImageView.kf.setImage(with: URL(string: image)) { result in
            switch result {
            case .success(let value):
                self.image = value.image
            case .failure(let error):
                ByeBooLogger.debug(error)
            }
        }
        
        rootView.imgCount = 1
        rootView.updateImageCountLabel(count: 1)
        rootView.imageContainer.changeIconHidden()
        rootView.confirmButton.updateType(.disabled)
        
        if questAnswer.isEmpty {
            rootView.questTextField.textView.text = "꼭 적지 않아도 괜찮지만, 글로 정리해 보면 스스로에게 한 걸음 더 가까워질 수 있어요."
        }
        else {
            rootView.questTextField.textView.text = questAnswer
            rootView.questTextField.textCount.text = "(\(questAnswer.count)/\(rootView.questTextField.limitCount))"
            rootView.questTextField.isPlaceholderActive = false
        }
    }
}

extension WriteActiveTypeQuestViewController: QuestCompleteProtocol {
    func changeCount(count: Int) {
        if count == 1 {
            rootView.confirmButton.updateType(.enabled)
        } else {
            rootView.confirmButton.updateType(.disabled)
        }
    }
    
    func updateButtonWhenWriting(text: String) {
        viewModel.action(.textFieldEditing(answerText: self.answerText, text: text, imgCount: rootView.imgCount))
    }
}
