//
//  TutorialModalView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/23/25.
//

import UIKit

final class TutorialModalView: BaseView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageStackView = UIStackView()
    private let tutorialImages: [UIImage] = [.worldFirst, .worldSecond, .worldThird, .worldFourth, .worldFifth]
    
    override func setStyle() {
        backgroundColor = .grayscale900
        imageStackView.do {
            $0.axis = .vertical
            $0.spacing = 32
        }
        tutorialImages.forEach {
            let imageView = UIImageView()
            let image = $0
            imageView.do {
                $0.image = image
                $0.contentMode = .scaleAspectFill
                $0.layer.cornerRadius = 12
            }
            imageStackView.addArrangedSubview(imageView)
            imageView.snp.makeConstraints {
                $0.width.equalTo(283.adjustedW)
            }
        }
    }
    
    override func setUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageStackView)
    }
    
    override func setLayout() {
        // iPhone Duo 대응: 오른쪽 세로 바(상태바, 탭 바)와 겹치지 않도록 좌우는 safe area 기준
        scrollView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        imageStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(24.adjustedH)
            // 이미지 폭이 고정이라 좌우를 붙이면 좁은 칸에서 제약이 충돌하므로 가운데 정렬
            $0.centerX.equalToSuperview()
        }
    }
}
