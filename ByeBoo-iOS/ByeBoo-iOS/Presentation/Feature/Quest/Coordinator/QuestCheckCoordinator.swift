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
    
    func moveFinishQuest() {
        let viewController = ViewControllerFactory.shared.makeFinishJourneyViewController()
        viewController.hidesBottomBarWhenPushed = true
        rootViewController?.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func moveArchive(quest: QuestEntity?) {
        let archiveQuestViewController = ViewControllerFactory.shared.makeArchiveQuestViewController()
        archiveQuestViewController.configure(questID: quest?.questId ?? 1, questType: quest?.questStyle ?? .activation)
        archiveQuestViewController.hidesBottomBarWhenPushed = true
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
        let questTipViewController = ViewControllerFactory.shared.makeQuestTipViewController()
        questTipViewController.configure(questID: quest?.questId ?? 1, questType: quest?.questStyle ?? .activation)
        questTipViewController.modalPresentationStyle = .fullScreen
        let topViewController = UIApplication.shared.topViewController()
        topViewController?.present(questTipViewController, animated: false)
    }
    
    func moveWriteQuest(quest: QuestEntity) {
        if quest.questStyle == .question {
            moveToWriteQuestion(questID: quest.questId, questNumber: quest.questNumber, questType: quest.questStyle)
        } else {
            moveToWriteActivity(questID: quest.questId, questNumber: quest.questNumber, questType: quest.questStyle)
        }
    }
    
    private func moveToWriteQuestion(questID: Int, questNumber: Int, questType: QuestType) {
        let questionQuestViewController = ViewControllerFactory.shared.makeWriteQuestionTypeQuestViewController()
        questionQuestViewController.configure(questID, questNumber, questType)
        rootViewController?.tabBarController?.tabBar.isHidden = true
        rootViewController?.navigationController?.pushViewController(questionQuestViewController, animated: false)
    }
    
    private func moveToWriteActivity(questID: Int, questNumber: Int, questType: QuestType) {
        let activationQuestViewController = ViewControllerFactory.shared.makeWriteActiveTypeQuestViewController()
        activationQuestViewController.configure(questID, questNumber, questType)
        rootViewController?.tabBarController?.tabBar.isHidden = true
        rootViewController?.navigationController?.pushViewController(activationQuestViewController, animated: false)
    }
}
