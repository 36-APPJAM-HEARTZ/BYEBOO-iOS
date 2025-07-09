//
//  JourneyResultViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

final class JourneyResultViewController: BaseViewController {

    private let rootView = JourneyResultView(
        name: "하츠핑",
        journeyType: .face,
        journeyDescription:
"""
너무 힘든 시간을 보내고 있는 당신에게, 
‘감정 직면 여정’을 추천해요.
  이 여정은 감정을 직면하고, 
상황을 정리하며, 점차 앞으로 나아가는
5단계로 구성되어 있어요.
  하루에 하나씩 기록해 나가다 보면, 
감정이 조금씩 정돈되고
마음이 가벼워질 거예요.
"""
    )
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setAddTarget() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(confirmLabelTapped))
        rootView.confirmLabel.addGestureRecognizer(tapRecognizer)
        rootView.confirmLabel.isUserInteractionEnabled = true
    }
}

extension JourneyResultViewController {
    @objc
    private func confirmLabelTapped() {
        let viewController = HomeOnboardingViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(viewController, animated: false)
    }
}
