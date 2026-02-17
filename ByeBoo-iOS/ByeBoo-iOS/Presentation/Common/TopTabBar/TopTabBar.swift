//
//  TopTabBar.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/12/26.
//

import UIKit

final class TopTabBar: UIStackView {
    
    private let itemViews: [TopTabBarItemView]
    var didTap: ((Int) -> Void)?
    
    init(items: [any TabItem]) {
        self.itemViews = items.map { TopTabBarItemView(item: $0) }
        super.init(frame: .zero)
        
        setStyle()
        setUI()
        setAction()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        self.do {
            $0.backgroundColor = .grayscale900
            $0.axis = .horizontal
            $0.spacing = 4
            $0.distribution = .fillEqually
        }
    }
    
    private func setUI() {
        itemViews.forEach { self.addArrangedSubview($0) }
    }
    
    private func setAction() {
        itemViews.enumerated().forEach { index, itemView in
            let tapGesture = UITapGestureRecognizer(
                target: self, action: #selector(barDidTap(_:))
            )
            itemView.addGestureRecognizer(tapGesture)
            itemView.tag = index
        }
        
        if let firstIndex = itemViews.indices.first {
            updateTabBar(tag: firstIndex)
        }
    }
}

extension TopTabBar {
    
    @objc
    private func barDidTap(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            return
        }
        
        didTap?(tag)
        updateTabBar(tag: tag)
    }
    
    private func updateTabBar(tag: Int) {
        itemViews.forEach { $0.updateBarItem(for: tag) }
    }
}
