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
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        imageStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(24.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(46.adjustedW)
        }
    }
}
