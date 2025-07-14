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
    
    let questID: Int = 0
    private var emotionState: String = ""
    
    override func loadView() {
        view = rootView
    }
    
    init(
        viewModel: WriteActiveTypeViewModel
    ){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .back,
            action: #selector(back)
        )
        
        setGesture()
        bind()
        presentPhotoPicker()
        viewModel.action(.viewDidLoad(quesetID: 1))
    }
    
    override func setAddTarget() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                let offsetY = keyboardSize.height
                self.rootView.transform = CGAffineTransform(translationX: 0, y: -offsetY)
            })
        }
    }
    
    @objc
    private func textViewMoveDown() {
        self.view.transform = .identity
    }
    
    @objc
    private func confirmButtonDidTap() {
        let viewController = EmotionBottomSheetViewController()
        viewController.previousView = .activation
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
    private func endEditingOnTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @objc
    private func tipTagDidTap() {
        ByeBooLogger.debug("탭 버튼 터치됨")
        let viewController = QuestTipViewController()
        viewController.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(viewController, animated: true)
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
    }
}

extension WriteActiveTypeQuestViewController: BackNavigable {
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
        }
        dismiss(animated: true, completion: nil)
    }
}

extension WriteActiveTypeQuestViewController: BottomSheetProtocol {
    func saveEmotionState(emotionState: ByeBooEmotion) {
        self.emotionState = emotionState.key
    }
    
    func presentNextViewController(from previousView: PreviousView) {
        guard let viewModel = DIContainer.shared.resolve(type: CompleteQuestViewModel.self) else {
            ByeBooLogger.error(ByeBooError.DIFailedError)
            fatalError()
        }
        let viewController = CompleteActiveTypeQuestViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
