//
//  WriteActiveTypeQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import Combine
import UIKit

final class WriteActiveTypeQuestViewController: BaseViewController {
    
    private let rootView = WriteActiveTypeQuestView()
    private let viewModel: WriteActiveTypeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var questID: Int = 1
    private var questType: QuestType = .activation
    private var questNumber: Int = 1
    
    private var answerText: String = ""
    private var emotionState: String = ""
    private var image: UIImage = UIImage()
    private var isKeyboardUsed: Bool = false
    
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
        bind()
        presentPhotoPicker()
        viewModel.action(.viewDidLoad(quesetID: questID))
    }
    
    override func setAddTarget() {
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
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
        if !self.isKeyboardUsed {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.3, animations: {
                    let offsetY = keyboardSize.height
                    self.rootView.transform = CGAffineTransform(translationX: 0, y: -offsetY)
                })
                self.isKeyboardUsed = true
            }
        }
    }
    
    @objc
    private func textViewMoveDown() {
        self.isKeyboardUsed = false
        self.view.transform = .identity
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
        
       
        bottomSheetViewController.delegate = self
        if let sheet =  bottomSheetViewController.sheetPresentationController{
            sheet.detents = [.custom { _ in 471.adjustedH }]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 8
        }
        self.present(bottomSheetViewController, animated: true)
    }
    
    @objc
    private func endEditingOnTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @objc
    private func tipTagDidTap() {
        let viewController = ViewControllerFactory.shared.makeQuestTipViewController()
        viewController.configure(questID: questID, questType: questType)
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
                    let viewController = ViewControllerFactory.shared.makeCompleteActiveTypeQuestViewController()
                    viewController.configure(questID: self?.questID ?? 1, questNumber: self?.questNumber ?? 1)
                    self?.bottomSheetViewController.dismiss(animated: true)
                    self?.navigationController?.pushViewController(viewController, animated: true)
                case .failure(let error):
                    self?.handleError(error)
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
            rootView.changeStyle(count: rootView.imgCount)
            self.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension WriteActiveTypeQuestViewController: BottomSheetProtocol {
    func saveEmotionState(emotionState: ByeBooEmotion) {
        self.emotionState = emotionState.key
    }
    
    func saveQuest() {
        let uuidKey = UUID().uuidString
        ByeBooLogger.debug("UUID: \(uuidKey)")
        self.viewModel.action(.didTapCompleteButton(
            questID: self.questID,
            answer: self.answerText,
            emotionState: self.emotionState,
            image: self.image,
            imageKey: uuidKey)
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
