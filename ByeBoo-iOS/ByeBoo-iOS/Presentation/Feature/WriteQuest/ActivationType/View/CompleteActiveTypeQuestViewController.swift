//
//  CompleteActiveTypeQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import UIKit

final class CompleteActiveTypeQuestViewController: BaseViewController {
    private let rootView = CompleteActiveTypeQuestView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ByeBooLogger.debug("뷰 디드로드")
    }
}
