//
//  EmotionBottomSheet.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/7/25.
//

import UIKit

import SnapKit

final class EmotionBottomSheetViewController: BaseViewController {
    private let rootView = EmotionBottomSheetView()
    private var selectedChip: ByeBooEmotionChip?
    weak var delegate: BottomSheetProtocol?
    
    override func loadView() {
        view = rootView
    }
    
    override func setAddTarget() {
        rootView.emotionChips.forEach { chip in
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(emotionChipDidTap(_:)))
            chip.addGestureRecognizer(tapRecognizer)
            chip.isUserInteractionEnabled = true
        }
        
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }
    
    @objc
    private func emotionChipDidTap(_ tapRecognizer: UITapGestureRecognizer) {
        guard let chip = tapRecognizer.view as? ByeBooEmotionChip else { return }
        if selectedChip === chip { return }
        selectedChip?.emotionTag.isSelected = false
        chip.emotionTag.isSelected = true
        selectedChip = chip
        
        let emotion = chip.emotionType
        chip.emotionTag.toggleTagType()
        rootView.confirmButton.updateType(.enabled)
        ByeBooLogger.debug("터치된 감정: \(emotion)")
    }
    
    @objc
    private func confirmButtonDidTap() {
        ByeBooLogger.debug("컨펌 버튼 터치됨")
        guard let selectedEmotion = selectedChip?.emotionType else {
            ByeBooLogger.debug("감정 선택 안됨")
            return
        }
        
        self.delegate?.saveEmotionState(emotionState: selectedEmotion)
        self.delegate?.saveQuest()
        rootView.confirmButton.isEnabled = false
    }
}
