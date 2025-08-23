//
//  QuestCoordinator.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/9/25.
//

import UIKit

final class QuestCheckCoordinator: QuestCheckCoordinating {
    
    private weak var rootViewController: QuestCheckViewController?
    
    init(rootViewController: QuestCheckViewController) {
        self.rootViewController = rootViewController
    }
    
    func moveQuestStart() {
        let viewController = ViewControllerFactory.shared.makeQuestStartViewController()
        viewController.modalPresentationStyle = .fullScreen
        rootViewController?.present(viewController, animated: false)
    }
    
    func moveArchive(quest: QuestEntity?) {
        guard let viewModel = DIContainer.shared.resolve(type: CompleteQuestViewModel.self) else { return }
        
        let questType: QuestType = (quest?.questStyle == QuestStyle.recording.key) ? .question : .activation
        let archiveQuestViewController = ArchiveQuestViewController(
            viewModel: viewModel,
            questID: quest?.questId ?? 1,
            questType: questType
        )
        rootViewController?.tabBarController?.tabBar.isHidden = true
        rootViewController?.navigationController?.pushViewController(archiveQuestViewController, animated: false)
    }
    
    func presentQuestModal(quest: QuestEntity?) {
        guard let quest = quest else { return }

        let onProgressQuest: (() -> Void) = {
            self.moveWriteQuest(quest: quest)
        }
        
        guard let rootViewController = rootViewController else { return }
        let modalBuilder = ModalBuilder(
            modalView: createQuestModalView(quest: quest),
            action: onProgressQuest,
            rootViewController: rootViewController
        )
        modalBuilder.present()
    }
    
    private func createQuestModalView(quest: QuestEntity) -> BaseView & ModalProtocol {
        let modalView = QuestModalView(questNumber: quest.questNumber, quest: quest.question)
        modalView.tipButton.addAction(UIAction { [weak self] _ in
            self?.moveQuestTip(quest: quest)
        }, for: .touchUpInside)
        return modalView
    }
    
    func moveQuestTip(quest: QuestEntity?) {
        guard let viewModel = DIContainer.shared.resolve(type: QuestTipViewModel.self),
              let questID = quest?.questId else {
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
    
    func moveWriteQuest(quest: QuestEntity) {
        if quest.questStyle == QuestStyle.recording.key {
            moveToWriteQuestion(questID: quest.questId)
            return
        }
        moveToWriteActivity(questID: quest.questId)
    }
    
    private func moveToWriteQuestion(questID: Int) {
        guard let viewModel = DIContainer.shared.resolve(type: WriteQuestionTypeViewModel.self) else {
            return
        }
        let questionQuestViewController = WriteQuestionTypeQuestViewController(
            viewModel: viewModel,
            questID: questID
        )
        rootViewController?.tabBarController?.tabBar.isHidden = true
        rootViewController?.navigationController?.pushViewController(questionQuestViewController, animated: false)
    }
    
    private func moveToWriteActivity(questID: Int) {
        guard let viewModel = DIContainer.shared.resolve(type: WriteActiveTypeViewModel.self) else {
            return
        }
        let activationQuestViewController = WriteActiveTypeQuestViewController(
            viewModel: viewModel,
            questID: questID
        )
        rootViewController?.tabBarController?.tabBar.isHidden = true
        rootViewController?.navigationController?.pushViewController(activationQuestViewController, animated: false)
    }
}
