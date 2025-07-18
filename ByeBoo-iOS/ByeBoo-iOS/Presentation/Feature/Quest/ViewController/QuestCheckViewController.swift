//
//  QuestCheckContentView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import Combine
import UIKit

import SnapKit

final class QuestCheckViewController: BaseViewController {
    
    private var allCompleted = false
    
    let questsCheckView = QuestsCheckView()
    private let viewModel: QuestsViewModel
    private var cancellable = Set<AnyCancellable>()
    private var questsEntity: ProgressingQuestsEntity?
    private var quest: QuestEntity?
    private var questID: Int?
    
    init(viewModel: QuestsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = questsCheckView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.alpha = 0
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        bind()
        viewModel.action(.questViewWillAppear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func setDelegate() {
        questsCheckView.questCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(
                QuestStateCell.self,
                forCellWithReuseIdentifier: QuestStateCell.identifier
            )
            $0.register(
                QuestStepHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: QuestStepHeaderView.identifier
            )
            $0.backgroundColor = .grayscale900
        }
    }
    
    private func bind() {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        
        Publishers.CombineLatest3(
            viewModel.output.namePublisher,
            viewModel.output.journeyPublisher,
            viewModel.output.questsPublisher
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] name, journey, quests in
            switch (name, journey, quests) {
            case let (.success(name), .success(journey), .success(quests)):
                self?.questsCheckView.questCheckHeaderView.updateHeader(
                    nickname: name,
                    journey: journey.title
                )
                self?.questsEntity = quests
                self?.questsCheckView.questCheckHeaderView.updatePeriod(quests.progressPeriod)
                self?.questsCheckView.questCollectionView.reloadData()
                
                guard let step = quests.steps.first else { return }
                if quests.currentStep > step.quests.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.scrollToStep()
                    }
                }
            case (.success(_), .success(_), .failure(_)):
                guard let startViewModel = DIContainer.shared.resolve(type: QuestStartViewModel.self) else {
                    ByeBooLogger.error(ByeBooError.DIFailedError)
                    fatalError()
                }
                
                let viewController = QuestStartViewController(viewModel: startViewModel)
                viewController.modalPresentationStyle = .fullScreen
                viewController.onStartedQuest = { [weak self] in
                    self?.viewModel.action(.questViewWillAppear)
                    self?.bind()
                }
                self?.present(viewController, animated: false)
                
            default:
                ByeBooLogger.error(ByeBooError.unknownError)
            }
        }
        .store(in: &cancellable)
        
        viewModel.output.loadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case true:
                    self?.view.alpha = 0
                case false:
                    UIView.animate(withDuration: 0.1) {
                        self?.view?.alpha = 1
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    private func scrollToStep() {
        guard let questsEntity = questsEntity else { return }
        for (sectionIndex, step) in questsEntity.steps.enumerated() {
            let collectionView = questsCheckView.questCollectionView
            
            if let _ = step.quests.firstIndex(where: { $0.questNumber == questsEntity.currentStep }) {
                // MARK: - 마지막 퀘스트 완료 시 STEP 1으로 스크롤
                if quest?.questNumber == 30 && allCompleted {
                    collectionView.scrollToHeader(at: 0)
                    return
                }
                
                // MARK: - 마지막 스텝 진입 시 맨 아래로 스크롤
                if step.stepNumber == 5 {
                    let maxOffsetY = collectionView.contentSize.height - collectionView.bounds.height + 30
                    let bottomOffset = CGPoint(
                        x: 0,
                        y: max(maxOffsetY, 0)
                    )
                    collectionView.setContentOffset(bottomOffset, animated: true)
                    return
                }
                
                // MARK: - 다음 스텝으로 넘어간 경우 해당 STEP으로 스크롤
                collectionView.scrollToHeader(at: sectionIndex)
                return
            }
        }
    }
}

extension QuestCheckViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        quest = questsEntity?.steps[indexPath.section].quests[indexPath.item]
        let currentStep = questsEntity?.currentStep
        
        questID = quest?.questId
        
        guard let step = currentStep,
              let questNumber = quest?.questNumber else {
            return
        }
        
        guard let viewModel = DIContainer.shared.resolve(type: CompleteQuestViewModel.self) else { return }
        
        if questNumber < step {
            let questType: QuestType = (quest?.questStyle == QuestStyle.recording.key) ? .question : .activation
            let archiveQuestViewController = ArchiveQuestViewController(
                viewModel: viewModel,
                questID: questID ?? 1,
                questType: questType
            )
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(archiveQuestViewController, animated: false)
            
        } else if questNumber == step {
            let onProgressQuest: (() -> Void) = { self.moveWriteQuest(quest: self.quest) }
            let modalView = QuestModalView(questNumber: questNumber, quest: quest?.question ?? "")
            modalView.tipButton.addTarget(self, action: #selector(tipButtonDidTap), for: .touchUpInside)
            
            let modalBuilder = ModalBuilder(
                modalView: modalView,
                action: onProgressQuest,
                rootViewController: self
            )
            modalBuilder.present()
        }
    }
    
    private func moveWriteQuest(quest: QuestEntity?) {
        if quest?.questNumber == 30 {
            allCompleted = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.questsCheckView.questCollectionView.scrollToHeader(at: 0)
            }
        }
        
        if quest?.questStyle == QuestStyle.recording.key {
            guard let viewModel = DIContainer.shared.resolve(type: WriteQuestionTypeViewModel.self),
                  let questID = quest?.questId else {
                return
            }
            let questionQuestViewController = WriteQuestionTypeQuestViewController(
                viewModel: viewModel,
                questID: questID
            )
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(questionQuestViewController, animated: false)
        } else {
            guard let viewModel = DIContainer.shared.resolve(type: WriteActiveTypeViewModel.self),
                  let questID = quest?.questId else {
                return
            }
            let activationQuestViewController = WriteActiveTypeQuestViewController(
                viewModel: viewModel,
                questID: questID
            )
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(activationQuestViewController, animated: false)
        }
    }
    
    @objc
    private func tipButtonDidTap() {
        
        guard let viewModel = DIContainer.shared.resolve(type: QuestTipViewModel.self),
              let questID = questID else {
            return
        }
        
        let questType: QuestType = (quest?.questStyle == QuestStyle.recording.key) ? .question : .activation
        let questTipViewController = QuestTipViewController(
            viewModel: viewModel,
            questID: questID,
            questType: questType
        )
        questTipViewController.modalPresentationStyle = .fullScreen
        let topViewController = UIApplication.shared.topViewController()
        topViewController?.present(questTipViewController, animated: false)
    }
}

extension QuestCheckViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return questsEntity?.steps.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questsEntity?.steps[section].quests.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: QuestStateCell.identifier,
            for: indexPath
        ) as? QuestStateCell,
              let quest = questsEntity?.steps[indexPath.section].quests[indexPath.item],
              let currentStep = questsEntity?.currentStep
        else {
            return UICollectionViewCell()
        }
        
        let state: QuestState
        if quest.questNumber < currentStep {
            state = .completed
        } else if quest.questNumber == currentStep {
            state = .ongoing
        } else {
            state = .locked
        }
        
        cell.bind(state: state, questNumber: quest.questNumber)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: QuestStepHeaderView.identifier,
            for: indexPath
        ) as? QuestStepHeaderView else {
            return UICollectionReusableView()
        }
        
        if let stepEntity = questsEntity?.steps[indexPath.section] {
            headerView.setStep(stepNumber: stepEntity.stepNumber, step: stepEntity.step)
        }
        
        return headerView
    }
}
