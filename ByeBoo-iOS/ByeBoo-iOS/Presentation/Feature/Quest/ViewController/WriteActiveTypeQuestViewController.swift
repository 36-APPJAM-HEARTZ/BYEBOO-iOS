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

final class WriteActiveTypeQuestViewController: WriteQuestBaseViewController<WriteActiveTypeQuestView> {

    private let viewModel: WriteActiveTypeViewModel
    private var cancellables = Set<AnyCancellable>()
    var questMode: QuestMode = .write
    
    private var questID: Int = 31
    private var questType: QuestType = .activation
    private var questNumber: Int = 1
    
    private var answerText: String = ""
    private var emotionState: String = ""
    private var image: UIImage = UIImage()

    private var isImageChanged: Bool = false
    private var originalImageKey: String = ""
    
    private let bottomSheetViewController = EmotionBottomSheetViewController()
    
    init(viewModel: WriteActiveTypeViewModel){
        self.viewModel = viewModel
        super.init(rootView: WriteActiveTypeQuestView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func setDelegate() {
        rootView.questTextField.questCompleteDelegate = self
        rootView.questTextField.questTextViewDelegate = self
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
        view.endEditing(true)
        if rootView.questTextField.textView.text == rootView.questTextField.placeholder ||
            rootView.questTextField.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            answerText = ""
        } else {
            answerText = rootView.questTextField.textView.text
        }
        
        if questMode == .edit {
            saveQuest(isEdit: true, isCommonQuest: nil)
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
        
    private func presentPhotoPicker() {
        rootView.imageContainer.didTapAddImage = { [weak self] in
            guard let self = self else { return }
            self.openPhotosButtenPressed()
        }
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
                        questNumber: quest.questNumber,
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
                    self.bottomSheetViewController.dismiss(animated: true)
                    ByeBooLogger.debug("퀘스트 아이디 \(self.questID)")
                    let archiveViewController = ViewControllerFactory.shared.makeArchiveQuestViewController()
                    archiveViewController.entryViewController = .writeQuest
                    archiveViewController.configure(questID: self.questID, questType: .activation)
                    self.navigationController?.pushViewController(archiveViewController, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        archiveViewController.presentCompleteModal()
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
                        questNumber: quest.questNumber,
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
                guard let self else { return }
                switch result {
                case true:
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                case false:
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
            }
            .store(in: &cancellables)
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
    
    func saveQuest(isEdit: Bool, isCommonQuest: Bool?) {
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
            isEdit: isEdit,
            isImageChanged: isImageChanged
        )
        )
    }
}

extension WriteActiveTypeQuestViewController {
    func configure(_ questID: Int, _ questNumber: Int, _ questType: QuestType, _ questionTitle: String?) {
        self.questID = questID
        self.questNumber = questNumber
        self.questType = questType
        
        self.questType = questType
        rootView.updateQuestTitle(
            questScope: .personal,
            questNumber: self.questNumber,
            question: questionTitle ?? ""
        )
    }
}

extension WriteActiveTypeQuestViewController: EditQuestProtocol {
    func getExistingQuest(
        questID: Int,
        questAnswer: String?,
        questNumber: Int?,
        image: String?,
        imageKey: String?)
    {
        self.questID = questID
        self.viewModel.action(.navigateFromArchiveViewController(questID: questID))
        guard let questAnswer = questAnswer,
              let questNumber = questNumber,
              let image = image,
              let imageKey = imageKey else { return }
        self.originalImageKey = imageKey
        self.answerText = questAnswer
        self.questNumber = questNumber
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
        rootView.textCountLabel.text = "\(answerText.count)/\(rootView.limitCount)"
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        if questAnswer.isEmpty {
            rootView.questTextField.textView.text = "꼭 적지 않아도 괜찮지만, 글로 정리해 보면 스스로에게 한 걸음 더 가까워질 수 있어요."
        }
        else {
            rootView.questTextField.textView.text = questAnswer
            applyTextViewGrowth()
            rootView.questTextField.isPlaceholderActive = false
        }
    }
}

extension WriteActiveTypeQuestViewController: QuestCompleteProtocol {
    func changeCount(count: Int) {
        if count == 1 {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func updateButtonWhenWriting(text: String) {
        viewModel.action(.textFieldEditing(answerText: self.answerText, text: text, imgCount: rootView.imgCount))
    }
}

extension WriteActiveTypeQuestViewController: WriteQuestTextViewProtocol {
    func textViewDidEndEditing() {
        self.rootView.questCountLabelView.textColor = .grayscale300
        self.rootView.updateUIWhenKeyboardDown()
    }
    
    func textViewDidChange(count: Int) {
        self.rootView.questCountLabelView.text = "\(count)/\(rootView.limitCount)"
        applyTextViewGrowth()
    }
}
