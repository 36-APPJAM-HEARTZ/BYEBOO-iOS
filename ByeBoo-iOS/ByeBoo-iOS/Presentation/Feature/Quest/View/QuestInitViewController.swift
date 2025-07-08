//
//  QuestInitViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

final class QuestInitViewController: BaseViewController {

    private let rootView = QuestInitView()
    
    override func loadView() {
        view = rootView
    }
}
