//
//  InformationViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/7/25.
//

import Combine
import UIKit

import Mixpanel

final class InformationViewController: BaseViewController {
    
    private let inputNicknameView = InputNicknameView()
    private let selectEmotionView = SelectEmotionView(emotionCardsView: EmotionCardsView())
    private let selectQuestView = SelectQuestView(questCardsView: QuestCardsView())
    private lazy var informationBaseView = InformationBaseView(
        informationView: inputNicknameView,
        progressBarType: .first
    )
    
    private var viewModel: InformationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: InformationViewModel) {
        self.viewModel = viewModel
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
        
        setTopNavigationBar(type: .none())
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
            action: type == .none() ? nil : #selector(back)
        )
    }
    
    private func setAddTarget(informationBaseView: InformationBaseView) {
        informationBaseView.nextButton.addTarget(
            self,
            action: #selector(nextButtonDidTap),
            for: .touchUpInside
        )
        inputNicknameView.nicknameTextField.onTextChange = { [weak self] text in
            guard let self = self else { return }
            
            self.inputNicknameView.nicknameStateView.letterCountLabel.text = "\(text.count)/\(5)"
            self.viewModel.action(.editingNickname(text))
        }
    }
}

extension InformationViewController {
    
    @objc
    private func nextButtonDidTap() {
        switch informationBaseView.informationView {
        case is InputNicknameView: saveNickname()
        case is SelectEmotionView: saveEmotion()
        case is SelectQuestView: saveQuest()
        default: break
        }
    }
    
    private func saveNickname() {
        if let nickname = inputNicknameView.nicknameTextField.nicknameField.text,
           !nickname.isEmpty {
            viewModel.action(.nicknameButtonDidTap(nickname))
            Mixpanel.mainInstance().track(event: CommonEvents.Name.nicknameComplete)
        }
        move(view: selectEmotionView, progress: .second)
    }
    
    private func saveEmotion() {
        let emotionCards = selectEmotionView.emotionCardsView.emotionCards
        for (index, emotionCard) in emotionCards.enumerated() where emotionCard.isSelected {
            if Feeling.allCases.indices.contains(index) {
                let feeling = Feeling.allCases[index]
                viewModel.action(.feelingButtonDidTap(feeling))
                Mixpanel.mainInstance().track(event: CommonEvents.Name.currentEmotionComplete)
                let userProperty = UserEvents.CurrentEmotionProperty(currentEmotion: feeling.mixpanelKey)
                Mixpanel.mainInstance().people.set(properties: userProperty.dictionary)
            }
        }
        move(view: selectQuestView, progress: .third)
    }
    
    private func saveQuest() {
        let questCards = selectQuestView.questCardsView.questCards
        for (index, questCard) in questCards.enumerated() where questCard.isSelected {
            if SelectQuestType.allCases.indices.contains(index) {
                let quest = SelectQuestType.allCases[index]
                viewModel.action(.questButtonDidTap(quest))
                let property = CommonEvents.SelectQuestTypeProperty(questType: quest.mixpanelKey)
                Mixpanel.mainInstance().track(
                    event: CommonEvents.Name.questTypeComplete,
                    properties: property.dictionary
                )
            }
        }
    }
}

extension InformationViewController: ToastPresentable, ToastErrorHandler {
    
    private func bind() {
        bindUserInformation()
        bindNicknameValidation()
    }
    
    private func bindUserInformation() {
        viewModel.output.userInformationPublisher
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.bindName()
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindNicknameValidation() {
        viewModel.output.nicknameValidationPublisher
            .sink { [weak self] result in
                guard let text = self?.inputNicknameView.nicknameTextField.nicknameField.text else {
                    return
                }
                self?.inputNicknameView.nicknameTextField.changeNicknameState(text: text, isValid: result)
                self?.informationBaseView.updateButtonWhenBack(condition: result)
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
    
    private func move(view: BaseView, progress: ProgressBarType) {
        self.informationBaseView.replace(informationView: view, progressBarType: progress)
        setAddTarget(informationBaseView: informationBaseView)
        
        switch view {
        case is InputNicknameView: setTopNavigationBar(type: .none())
        case is SelectEmotionView, is SelectQuestView: setTopNavigationBar(type: .back())
        default: break
        }
    }
}

extension InformationViewController: BackNavigable {
    
    func back() {
        switch informationBaseView.informationView {
        case is SelectEmotionView:
            selectEmotionView.resetSelected()
            move(view: inputNicknameView, progress: .first)
        case is SelectQuestView:
            selectQuestView.resetSelected()
            move(view: selectEmotionView, progress: .second)
        default:
            break
        }
    }
}
