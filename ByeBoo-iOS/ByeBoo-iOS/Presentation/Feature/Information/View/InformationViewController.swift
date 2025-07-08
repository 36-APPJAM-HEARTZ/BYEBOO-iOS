//
//  InformationViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/7/25.
//

import UIKit

final class InformationViewController: BaseViewController {
    
    private var informationViewType: InformationViewType
    private var progressBarType: ProgressBarType
        
    private lazy var inputNicknameView = InputNicknameView()
    private lazy var selectEmotionView = SelectEmotionView(emotionCardsView: EmotionCardsView())
    private lazy var selectQuestView = SelectQuestView(questCardsView: QuestCardsView())
    
    private lazy var inputNicknameType = InformationViewType.inputNickname(inputNicknameView)
    private lazy var selectEmotionType = InformationViewType.selectEmotion(selectEmotionView)
    private lazy var selectQuestType = InformationViewType.selectQuest(selectQuestView)
        
    init(
        informationViewType: InformationViewType,
        progressBarType: ProgressBarType
    ) {
        self.informationViewType = informationViewType
        self.progressBarType = progressBarType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var informationBaseView = InformationBaseView(
        informationViewType: informationViewType,
        progressBarType: progressBarType
    )
    
    override func loadView() {
        view = informationBaseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .back,
            action: #selector(back)
        )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if let inputNicknameView = informationBaseView.informationView as? InputNicknameView {
            inputNicknameView.nicknameTextField.setTextFieldStyle(.onBeginEditing)
        }
    }
    
    override func setAddTarget() {
        informationBaseView.nextButton.addTarget(
            self,
            action: #selector(nextButtonDidTap),
            for: .touchUpInside
        )
    }
}

extension InformationViewController: BackNavigable {
    
    func back() {
        switch informationViewType {
        case .inputNickname:
            print("온보딩 화면으로")
        case .selectEmotion:
            moveTo(viewType: inputNicknameType, progress: .first)
        case .selectQuest:
            moveTo(viewType: selectEmotionType, progress: .second)
        }
    }
}

extension InformationViewController {
    
    @objc
    func nextButtonDidTap() {
        switch informationViewType {
        case .inputNickname:
            moveTo(viewType: selectEmotionType, progress: .second)
            
        case .selectEmotion:
            moveTo(viewType: selectQuestType, progress: .third)
            
        case .selectQuest:
            print("로딩 화면")
        }
    }
    
    private func moveTo(viewType: InformationViewType?, progress: ProgressBarType) {
        guard let viewType else { return }
        self.informationViewType = viewType
        let newView = InformationBaseView(
            informationViewType: viewType,
            progressBarType: progress
        )
        self.view = newView
        newView.nextButton.addTarget(
            self,
            action: #selector(nextButtonDidTap),
            for: .touchUpInside
        )
    }
}
