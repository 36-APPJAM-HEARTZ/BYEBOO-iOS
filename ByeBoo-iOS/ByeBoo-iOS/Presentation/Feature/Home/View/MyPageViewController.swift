//
//  MyPageViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/5/25.
//

import UIKit

import SnapKit
import Then

final class MyPageViewController: BaseViewController {
    
    private let text = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(text)
        setUI()
        setLayout()
    }
    
    private func setUI() {
        text.do {
            $0.text = "내정보"
            $0.textColor = .white
        }
    }
    
    private func setLayout() {
        text.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
