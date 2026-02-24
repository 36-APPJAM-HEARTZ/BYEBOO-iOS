//
//  CommonQuestBottomSheetView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 2/23/26.
//

import UIKit

import SnapKit

final class CommonQuestBottomSheetView: BaseView {
    private let sheetType: CommonQuestArchiveType
    private let contentStackView = UIStackView()
    private(set) var dismissButton = ByeBooButton(titleText: "닫기", type: .disabled)
    private(set) var itemList: [UIStackView] = []
    
    init(sheetType: CommonQuestArchiveType) {
        self.sheetType = sheetType
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        addSubviews(contentStackView, dismissButton)
        
        sheetType.items.enumerated().forEach { index, item in
            let rowView = makeItemRow(item: item)
            itemList.append(rowView)
            contentStackView.addArrangedSubview(rowView)

            if index != sheetType.items.count - 1 {
                let divider = SectionDividerView()
                contentStackView.addArrangedSubview(divider)
            }
        }
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 20
        }
        
        dismissButton.isEnabled = true
    }
    
    override func setLayout() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(42.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
        
        dismissButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(36.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
    }
}

private extension CommonQuestBottomSheetView {
    func makeItemRow(item: CommonQuestArchiveType.Item) -> UIStackView {
        let icon = UIImageView(image: item.icon)
        let label = UILabel()
        
        label.applyByeBooFont(style: .body3R16, text: item.title, color: item.color)
        
        let stackView = UIStackView()
        
        icon.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 12.adjustedW
        }
        stackView.addArrangedSubviews(icon, label)
        return stackView
    }
}
