//
//  InformationViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/7/25.
//

import UIKit

final class InformationViewController: BaseViewController {
    
    private let inputNicknameView: InputNicknameView
    private var informationViewType: InformationViewType
    private var informationBaseView: InformationBaseView
    
    private let selectEmotionView = SelectEmotionView(emotionCardsView: EmotionCardsView())
    private let selectQuestView = SelectQuestView(questCardsView: QuestCardsView())
    
    private lazy var inputNicknameType = InformationViewType.inputNickname(inputNicknameView)
    private lazy var selectEmotionType = InformationViewType.selectEmotion(selectEmotionView)
    private lazy var selectQuestType = InformationViewType.selectQuest(selectQuestView)
        
    init(progressBarType: ProgressBarType) {
        self.inputNicknameView = InputNicknameView()
        self.informationViewType = .inputNickname(self.inputNicknameView)
        self.informationBaseView = InformationBaseView(
            informationViewType: self.informationViewType,
            progressBarType: progressBarType
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        setAddTarget(informationBaseView: informationBaseView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if let inputNicknameView = informationBaseView.informationView as? InputNicknameView {
            inputNicknameView.nicknameTextField.setTextFieldStyle(.onBeginEditing)
        }
    }
    
    private func setAddTarget(informationBaseView: InformationBaseView) {
        informationBaseView.nextButton.addTarget(
            self,
            action: #selector(nextButtonDidTap),
            for: .touchUpInside
        )
    }
}

extension InformationViewController {
    
    private func move(viewType: InformationViewType, progress: ProgressBarType) {
        self.informationViewType = viewType
        let newBaseView = InformationBaseView(
            informationViewType: viewType,
            progressBarType: progress
        )
        self.view = newBaseView
        setAddTarget(informationBaseView: newBaseView)
    }
}

extension InformationViewController: BackNavigable {
    
    func back() {
        switch informationViewType {
        case .inputNickname: ByeBooLogger.data("Input Nickname")
        case .selectEmotion: move(viewType: inputNicknameType, progress: .first)
        case .selectQuest: move(viewType: selectEmotionType, progress: .second)
        }
    }
}

extension InformationViewController {
    
    @objc
    private func nextButtonDidTap() {
        switch informationViewType {
        case .inputNickname: move(viewType: selectEmotionType, progress: .second)
        case .selectEmotion: move(viewType: selectQuestType, progress: .third)
        case .selectQuest: ByeBooLogger.data("Loading")
        }
    }
}
