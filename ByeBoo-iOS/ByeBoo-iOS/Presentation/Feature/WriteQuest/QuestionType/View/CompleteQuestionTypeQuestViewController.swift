//
//  CompleteQuestionTypeQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import UIKit

final class CompleteQuestionTypeQuestViewController: BaseViewController {
    private let rootView = CompleteQuestionTypeQuestView()
    
    override func loadView() {
        view = rootView
    }
}
