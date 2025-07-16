//
//  InformationViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/7/25.
//

import Combine
import UIKit

final class InformationViewController: BaseViewController {
    
    private let inputNicknameView: InputNicknameView
    private var informationViewType: InformationViewType
    private var informationBaseView: InformationBaseView
    private var maxStep: ProgressBarType
    
    private let selectEmotionView = SelectEmotionView(emotionCardsView: EmotionCardsView())
    private let selectQuestView = SelectQuestView(questCardsView: QuestCardsView())
    
    private lazy var inputNicknameType = InformationViewType.inputNickname(inputNicknameView)
    private lazy var selectEmotionType = InformationViewType.selectEmotion(selectEmotionView)
    private lazy var selectQuestType = InformationViewType.selectQuest(selectQuestView)
    
    private var viewModel: InformationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: InformationViewModel) {
        self.inputNicknameView = InputNicknameView()
        self.informationViewType = .inputNickname(self.inputNicknameView)
        self.informationBaseView = InformationBaseView(
            informationViewType: self.informationViewType,
            progressBarType: .first
        )
        self.viewModel = viewModel
        self.maxStep = .first
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
        
        setTopNavigationBar(type: .none)
        setAddTarget(informationBaseView: informationBaseView)
        bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if let inputNicknameView = informationBaseView.informationView as? InputNicknameView {
            inputNicknameView.nicknameTextField.setTextFieldStyle(.onBeginEditing)
        }
    }
    
    private func setTopNavigationBar(type: NavigationBarType) {
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: type,
            action: type == .none ? nil : #selector(back)
        )
    }
    
    private func setAddTarget(informationBaseView: InformationBaseView) {
        informationBaseView.nextButton.addTarget(
            self,
            action: #selector(nextButtonDidTap),
            for: .touchUpInside
        )
    }
    
    private func bind() {
        viewModel.output.userInformationPublisher
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.bindName()
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindName() {
        viewModel.output.userNamePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let userName):
                    let loadingViewController = LoadingViewController()
                    loadingViewController.nickname = userName
                    loadingViewController.navigationItem.hidesBackButton = true
                    self?.navigationController?.pushViewController(loadingViewController, animated: false)
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

extension InformationViewController {
    
    private func move(viewType: InformationViewType, progress: ProgressBarType) {
        if progress.rawValue > maxStep.rawValue {
            maxStep = progress
        }
        
        self.informationViewType = viewType
        let newBaseView = InformationBaseView(
            informationViewType: viewType,
            progressBarType: progress
        )
        self.view = newBaseView
        setAddTarget(informationBaseView: newBaseView)
        
        switch viewType {
        case .inputNickname:
            if maxStep == .third {
                viewModel.resetData()
                selectEmotionView.resetSelected()
                selectQuestView.resetSelected()
                maxStep = .first
            }
            setTopNavigationBar(type: .none)
        default:
            setTopNavigationBar(type: .back)
        }
    }
}

extension InformationViewController: BackNavigable {
    
    func back() {
        switch informationViewType {
        case .selectEmotion:
            move(viewType: inputNicknameType, progress: .first)
        case .selectQuest:
            move(viewType: selectEmotionType, progress: .second)
        default:
            break
        }
    }
}

extension InformationViewController {
    
    @objc
    private func nextButtonDidTap() {
        switch informationViewType {
        case .inputNickname:
            if let nickname = inputNicknameView.nicknameTextField.nicknameField.text,
               !nickname.isEmpty {
                viewModel.action(.nicknameButtonDidTap(nickname))
            }
            move(viewType: selectEmotionType, progress: .second)
            
        case .selectEmotion:
            let emotionCards = selectEmotionView.emotionCardsView.emotionCards
            for (index, emotionCard) in emotionCards.enumerated() where emotionCard.isSelected {
                if Feeling.allCases.indices.contains(index) {
                    let feeling = Feeling.allCases[index]
                    viewModel.action(.feelingButtonDidTap(feeling))
                }
            }
            move(viewType: selectQuestType, progress: .third)
            
        case .selectQuest:
            let questCards = selectQuestView.questCardsView.questCards
            for (index, questCard) in questCards.enumerated() where questCard.isSelected {
                if QuestStyle.allCases.indices.contains(index) {
                    let quest = QuestStyle.allCases[index]
                    viewModel.action(.questButtonDidTap(quest))
                }
            }
        }
    }
}
