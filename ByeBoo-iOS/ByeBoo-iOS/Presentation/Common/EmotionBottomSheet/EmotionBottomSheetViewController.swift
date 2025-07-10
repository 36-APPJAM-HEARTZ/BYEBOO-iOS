//
//  EmotionBottomSheet.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/7/25.
//

import UIKit

import SnapKit

enum PreviousView {
    case activation
    case question
}

final class EmotionBottomSheetViewController: BaseViewController {
    private let rootView = EmotionBottomSheetView()
    private var selectedChip: ByeBooEmotionChip?
    var previousView: PreviousView?
    weak var delegate: BottomSheetProtocol?
    
    override func loadView() {
        view = rootView
    }
    
    override func setAddTarget() {
        rootView.emotionChips.forEach { chip in
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(emotionChipDidTapped(_:)))
            chip.addGestureRecognizer(tapRecognizer)
            chip.isUserInteractionEnabled = true
        }
        
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func emotionChipDidTapped(_ tapRecognizer: UITapGestureRecognizer) {
        guard let chip = tapRecognizer.view as? ByeBooEmotionChip else { return }
        if selectedChip === chip { return }
        selectedChip?.emotionTag.isSelected = false
        chip.emotionTag.isSelected = true
        selectedChip = chip
        
        let emotion = chip.emotionType.emotionText
        chip.emotionTag.toggleTagType()
        rootView.confirmButton.updateType(.enabled)
        
        ByeBooLogger.debug("터치된 감정: \(emotion)")
    }
    
    @objc
    private func confirmButtonTapped() {
        ByeBooLogger.debug("컨펌 버튼 터치됨")
        if let previousView = previousView {
            ByeBooLogger.debug(previousView)
            
            self.dismiss(animated: true) {
                self.delegate?.presentNextVC(from: previousView)
            }
        }
    }
}
