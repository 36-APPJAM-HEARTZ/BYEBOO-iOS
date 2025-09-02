//
//  CompletedQuestsViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 9/1/25.
//

import Combine
import UIKit

import SnapKit

final class CompletedQuestsViewController: BaseViewController {
    
    private let questsCheckView = ViewAllQuestBaseView(headerView: CompletedQuestsHeaderView())
    private let viewModel: CompletedQuestsViewModel
    private var cancellable = Set<AnyCancellable>()
    
    private var journeyTitle: String?
        
    init(viewModel: CompletedQuestsViewModel) {
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
        
        bind()
        if let journeyTitle {
            viewModel.action(.viewWillAppear(journey: journeyTitle))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .close(header: .black),
            action: #selector(close)
        )
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

extension CompletedQuestsViewController: Dismissible {
    
    func close() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension CompletedQuestsViewController {
    
    func configure(journey: String) {
        self.journeyTitle = journey
    }
}

extension CompletedQuestsViewController: ToastPresentable, ToastErrorHandler {
    
    func bind() {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        
        bindQuestData()
    }
    
    private func bindQuestData() {
        Publishers.CombineLatest(
            viewModel.output.namePublisher,
            viewModel.output.questsPublisher
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in
            switch result {
            case let (.success(name), .success(quests)):
                if let journeyTitle = self?.journeyTitle {
                    self?.updateQuestMainUI(name: name, journey: journeyTitle, quests: quests)
                }
            case (.success, .failure(let error)):
                self?.handleError(error)
            default:
                ByeBooLogger.error(ByeBooError.unknownError)
            }
        }
        .store(in: &cancellable)
    }
}

extension CompletedQuestsViewController {
    
    private func updateQuestMainUI(
        name: String,
        journey: String,
        quests: CompletedQuestsEntity
    ) {
        self.questsCheckView.questCheckHeaderView.configure(
            nickname: name,
            journey: journey,
            period: "\(quests.progressPeriod)"
        )
        self.questsCheckView.questCollectionView.reloadData()
    }
}

extension CompletedQuestsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let quest = viewModel.getQuest(section: indexPath.section, item: indexPath.item)
        
        let archiveQuestController = ViewControllerFactory.shared.makeArchiveQuestViewController()
        archiveQuestController.configure(questID: quest?.questId ?? 1, questType: quest?.questStyle ?? .activation)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(archiveQuestController, animated: false)
    }
}

extension CompletedQuestsViewController: UICollectionViewDataSource {
    
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
        
        cell.bind(state: .completed, questNumber: quest.questNumber)
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
