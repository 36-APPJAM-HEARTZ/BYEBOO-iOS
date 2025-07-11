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
    
    private let questCheckHeaderView: QuestCheckHeaderView
    private let viewModel: QuestsViewModel
    private var cancellable = Set<AnyCancellable>()
    private var questsEntity: QuestsEntity?
    
    init(
        questCheckHeaderView: QuestCheckHeaderView,
        viewModel: QuestsViewModel
    ) {
        self.questCheckHeaderView = questCheckHeaderView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var questCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CollectionViewFactory.createLayout()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        bind()
        viewModel.action(.handleStartQuestButtonDidTap)
    }
    
    override func setView() {
        view.addSubviews(questCheckHeaderView, questCollectionView)
        
        questCheckHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(129.adjustedH)
        }
        questCollectionView.snp.makeConstraints {
            $0.top.equalTo(questCheckHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setDelegate() {
        questCollectionView.do {
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
            $0.backgroundColor = .black
        }
    }
    
    private func bind() {
        viewModel.output.questsPublisher
            .sink { result in
                switch result {
                case .success(let questsEntity):
                    self.questsEntity = questsEntity
                    self.questCheckHeaderView.updatePeriod(questsEntity.progressPeriod)
                    self.questCollectionView.reloadData()
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
                let indexPath = IndexPath(item: questIndex, section: sectionIndex)
                questCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                return
            }
        }
    }
}

extension QuestCheckViewController: UICollectionViewDelegateFlowLayout {
    
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
        
        cell.dataBind(state: state, questNumber: quest.questNumber)
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
