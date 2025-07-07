//
//  EmotionBottomSheet.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/7/25.
//

import UIKit

import SnapKit

final class EmotionBottomSheetViewController: BaseViewController {
    private let bottomSheetView = EmotionBottomSheetView()
    private var selectedChip: ByeBooEmotionChip?

    override func setView() {
        view.addSubview(bottomSheetView)
        bottomSheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setAddTarget() {
        bottomSheetView.emotionChips.forEach { chip in
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(emotionChipDidTapped(_:)))
            chip.addGestureRecognizer(tapRecognizer)
            chip.isUserInteractionEnabled = true
        }
        
        bottomSheetView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
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
        ByeBooLogger.debug("터치된 감정: \(emotion)")
    }
    
    @objc
    private func confirmButtonTapped() {
        ByeBooLogger.debug("컨펌 버튼 터치됨")
    }
                                                          
}
