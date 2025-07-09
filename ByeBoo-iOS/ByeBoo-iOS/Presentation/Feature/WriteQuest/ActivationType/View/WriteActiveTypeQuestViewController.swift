//
//  WriteActiveTypeQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import UIKit

final class WriteActiveTypeQuestViewController: BaseViewController {
    
    private let rootView = WriteActiveTypeQuestView()
    
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
        
        setGesture()
        presentPhotoPicker()
    }
    
    override func setAddTarget() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTapped), for: .touchUpInside)
        rootView.title.tipTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tipTagDidTap)))
    }
    
    private func setGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditingOnTap))
        ByeBooLogger.debug(tapGestureRecognizer)
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.cancelsTouchesInView = false
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
    private func confirmButtonDidTapped() {
        
    }
    
    @objc
    private func endEditingOnTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
}

extension WriteActiveTypeQuestViewController: BackNavigable {
    func back() {
        
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

extension WriteActiveTypeQuestViewController: TipTagDidTapProtocol {
    func tipTagDidTap() {
        
    }
}
