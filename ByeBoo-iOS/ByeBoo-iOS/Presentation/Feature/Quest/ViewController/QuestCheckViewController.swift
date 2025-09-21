//
//  QuestCheckContentView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import Combine
import UIKit

import SnapKit
import Mixpanel

final class QuestCheckViewController: BaseViewController {
    
    private static let lastStep = 5
    
    private let questsCheckView = ViewAllQuestBaseView(headerView: QuestCheckHeaderView())
    private let viewModel: ProgressingQuestsViewModel
    var coordinator: QuestCheckCoordinating?
    private var cancellable = Set<AnyCancellable>()
    
    private var journeyType: JourneyType = .face
    private var isFirst: Bool = true
    
    init(viewModel: ProgressingQuestsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.coordinator = QuestCheckCoordinator(rootViewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = questsCheckView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        bind()
        viewModel.action(.questViewWillAppear)
        
        let property = QuestEvents.QuestMainProperty(
            journeyType: journeyType.mixpanelKey,
            isFirstPageView: isFirst
        )
        Mixpanel.mainInstance().track(
            event: QuestEvents.Name.questPageView,
            properties: property.dictionary
        )
        
        if isFirst { isFirst.toggle() }
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
}

extension QuestCheckViewController: ToastPresentable, ToastErrorHandler {
    
    func bind() {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        
        bindQuestData()
        bindLoading()
        bindTimer()
    }
    
    private func bindQuestData() {
        Publishers.CombineLatest3(
            viewModel.output.namePublisher,
            viewModel.output.journeyPublisher,
            viewModel.output.questsPublisher
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] name, journey, quests in
            switch (name, journey, quests) {
            case let (.success(name), .success(journey), .success(quests)):
                self?.updateQuestMainUI(name: name, journey: journey, quests: quests)
            case (.success(_), .success(_), .failure(_)):
                self?.coordinator?.moveQuestStart()
            case (.success(_), .failure(_), .failure(_)):
                self?.coordinator?.moveFinishQuest()
            case (_, .failure(let error), _), (_, _, .failure(let error)):
                self?.handleError(error)
            default:
                ByeBooLogger.error(ByeBooError.unknownError)
            }
        }
        .store(in: &cancellable)
    }
    
    private func bindLoading() {
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
    
    private func bindTimer() {
        viewModel.output.timePublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success(let time):
                    let indexPath = self.viewModel.currentQuestIndexPath
                    let cell = self.questsCheckView.questCollectionView.cellForItem(at: indexPath)
                    if let questStateCell = cell as? QuestStateCell {
                        questStateCell.updateRemainingTime(time)
                    }
                case .failure:
                    self.viewModel.action(.questOpen)
                }
            }
            .store(in: &cancellable)
    }
}

extension QuestCheckViewController {
    
    private func updateQuestMainUI(
        name: String,
        journey: JourneyEntity,
        quests: ProgressingQuestsEntity
    ) {
        self.questsCheckView.questCheckHeaderView.configure(
            nickname: name,
            journey: journey.title,
            period: "\(quests.progressPeriod)"
        )
        self.questsCheckView.questCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scrollToStep()
        }
    }
    
    private func scrollToStep() {
        guard let sectionIndex = findCurrentStepSectionIndex(),
              let step = viewModel.getStep(section: sectionIndex) else { return }
       
        if isLastStep(stepNumber: step.stepNumber) {
            scrollToBottom()
            return
        }
        scrollToHeader(at: sectionIndex)
    }
    
    private func findCurrentStepSectionIndex() -> Int? {
        for (sectionIndex, step) in viewModel.steps.enumerated() {
            if step.quests.contains(where: { $0.questNumber == viewModel.currentStep }) {
                return sectionIndex
            }
        }
        return nil
    }
    
    private func isLastStep(stepNumber: Int) -> Bool {
        stepNumber == QuestCheckViewController.lastStep
    }
    
    private func scrollToBottom() {
        let collectionView = questsCheckView.questCollectionView
        let extraOffset: CGFloat = 80
        let maxOffset = collectionView.contentSize.height - collectionView.bounds.height
        let targetOffset = max(maxOffset + extraOffset, 0)
        
        collectionView.setContentOffset(CGPoint(x: 0, y: targetOffset), animated: true)
    }
    
    private func scrollToHeader(at sectionIndex: Int) {
        let collectionView = questsCheckView.questCollectionView
        collectionView.scrollToHeader(at: sectionIndex)
    }
}

extension QuestCheckViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let quest = viewModel.getQuest(section: indexPath.section, item: indexPath.item)
        let currentStep = viewModel.currentStep
        
        guard let questNumber = quest?.questNumber else {
            return
        }
        if questNumber < currentStep {
            coordinator?.moveArchive(quest: quest)
            let property = QuestEvents.QuestBoxClickProperty(questNumber: questNumber)
            Mixpanel.mainInstance().track(
                event: QuestEvents.Name.questBoxClick,
                properties: property.dictionary
            )
        }
        if questNumber == currentStep && !viewModel.isQuestLocked {
            coordinator?.presentQuestModal(quest: quest)
        }
    }
}

extension QuestCheckViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.steps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getQuestsCount(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: QuestStateCell.identifier,
            for: indexPath
        ) as? QuestStateCell, let quest = viewModel.getQuest(section: indexPath.section, item: indexPath.item) else {
            return UICollectionViewCell()
        }
        
        let state = viewModel.getQuestState(questNumber: quest.questNumber)
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
        
        if let stepEntity = viewModel.getStep(section: indexPath.section) {
            headerView.setStep(stepNumber: stepEntity.stepNumber, step: stepEntity.step)
        }
        return headerView
    }
}
