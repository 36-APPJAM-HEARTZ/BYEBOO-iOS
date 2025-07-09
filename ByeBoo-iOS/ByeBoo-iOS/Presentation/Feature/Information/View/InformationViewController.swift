//
//  InformationViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/7/25.
//

import UIKit

import Combine

final class InformationViewController: BaseViewController {
    
    private let inputNicknameView: InputNicknameView
    private var informationViewType: InformationViewType
    private var informationBaseView: InformationBaseView
    
    private let selectEmotionView = SelectEmotionView(emotionCardsView: EmotionCardsView())
    private let selectQuestView = SelectQuestView(questCardsView: QuestCardsView())
    
    private lazy var inputNicknameType = InformationViewType.inputNickname(inputNicknameView)
    private lazy var selectEmotionType = InformationViewType.selectEmotion(selectEmotionView)
    private lazy var selectQuestType = InformationViewType.selectQuest(selectQuestView)
    
    private var viewModel = InformationViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.inputNicknameView = InputNicknameView()
        self.informationViewType = .inputNickname(self.inputNicknameView)
        self.informationBaseView = InformationBaseView(
            informationViewType: self.informationViewType,
            progressBarType: .first
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
        
        setTopNavigationBar(type: .none)
        setAddTarget(informationBaseView: informationBaseView)
        bindViewModel()
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
    
    private func bindViewModel() {
        viewModel.output.userInformationPublisher
            .sink { result in
                switch result {
                case .success(let user):
                    // 닉네임 들고 로딩 뷰로 이동하기
                    print("유저의 닉네임 : \(user.name)")
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
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
        
        switch viewType {
        case .inputNickname:
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
            for index in 0..<emotionCards.count {
                if emotionCards[index].isSelected {
                    switch index {
                    case 0:
                        viewModel.action(.emotionButtonDidTap(.exhausted))
                    case 1:
                        viewModel.action(.emotionButtonDidTap(.recovering))
                    case 2:
                        viewModel.action(.emotionButtonDidTap(.overcoming))
                    default:
                        break
                    }
                }
            }
            move(viewType: selectQuestType, progress: .third)
            
        case .selectQuest:
            let questCards = selectQuestView.questCardsView.questCards
            for index in 0..<questCards.count {
                if questCards[index].isSelected {
                    switch index {
                    case 0:
                        viewModel.action(.questButtonDidTap(.recording))
                    case 1:
                        viewModel.action(.questButtonDidTap(.active))
                    default:
                        break
                    }
                }
            }
        }
    }
}
