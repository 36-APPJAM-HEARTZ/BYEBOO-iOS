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
    
    let questsCheckView = QuestsCheckView()
    private let viewModel: QuestsViewModel
    private var cancellable = Set<AnyCancellable>()
    private var questsEntity: ProgressingQuestsEntity?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // state가 before journey인 경우
        // 요거 viewDidLoad말고 다른 곳에서 해주어야 함 !!!!!!
//        guard let startViewModel = DIContainer.shared.resolve(type: QuestStartViewModel.self) else {
//            ByeBooLogger.error(ByeBooError.DIFailedError)
//            fatalError()
//        }
//        
//        let viewController = QuestStartViewController(viewModel: startViewModel)
//        viewController.modalPresentationStyle = .fullScreen
//        self.present(viewController, animated: false)
        
        bind()
        viewModel.action(.handleStartQuestButtonDidTap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func setDelegate() {
        questsCheckView.questCollectionView.do {
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
            $0.backgroundColor = .black
        }
    }
    
    private func bind() {
        viewModel.output.questsPublisher
            .sink { result in
                switch result {
                case .success(let questsEntity):
                    self.questsEntity = questsEntity
                    self.questsCheckView.questCheckHeaderView.updatePeriod(questsEntity.progressPeriod)
                    self.questsCheckView.questCheckHeaderView.updateHeader(nickname: "파카", journeyType: .face)
                    self.questsCheckView.questCollectionView.reloadData()
                    guard let step = questsEntity.steps.first else { return }
                    if questsEntity.currentStep > step.quests.count {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.scrollToCurrentStep()
                        }
                    }
                case .failure:
                    break
                }
            }
            .store(in: &cancellable)
    }
    
    private func scrollToCurrentStep() {
        guard let questsEntity = questsEntity else { return }
        for (sectionIndex, step) in questsEntity.steps.enumerated() {
            if let questIndex = step.quests.firstIndex(
                where: {
                    $0.questNumber == questsEntity.currentStep
                }) {
                let indexPath = IndexPath(item: 0, section: sectionIndex)
                
                if let attributes = questsCheckView.questCollectionView.layoutAttributesForSupplementaryElement(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    at: indexPath
                ) {
                    let offsetY = attributes.frame.origin.y - questsCheckView.questCollectionView.contentInset.top
                    questsCheckView.questCollectionView.setContentOffset(
                        CGPoint(x: 0, y: offsetY.adjustedH),
                        animated: true
                    )
                }
                return
            }
        }
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
