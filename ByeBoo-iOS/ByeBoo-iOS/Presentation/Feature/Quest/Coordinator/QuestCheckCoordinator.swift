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
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        rootViewController?.present(navigationController, animated: false)
    }
    
    func moveFinishQuest() {
        let viewController = ViewControllerFactory.shared.makeFinishJourneyViewController()
        viewController.hidesBottomBarWhenPushed = true
        rootViewController?.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func moveArchive(quest: QuestEntity?) {
        let archiveQuestViewController = ViewControllerFactory.shared.makeArchiveQuestViewController()
        archiveQuestViewController.entryViewController = .questMain
        archiveQuestViewController.configure(questID: quest?.questId ?? 1, questType: quest?.questStyle ?? .activation)
        archiveQuestViewController.hidesBottomBarWhenPushed = true
        // 펼친 iPhone Duo에서는 목록 오른쪽에, 그 외에는 push
        rootViewController?.showDetail(archiveQuestViewController)
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
        questTipViewController.bind(questID: quest?.questId ?? 1, questType: quest?.questStyle ?? .activation, questNumber: quest?.questNumber ?? 1)
        let topViewController = UIApplication.shared.topViewController()
        
        // 펼친 iPhone Duo에서는 모달을 닫고 목록 오른쪽에, 그 외에는 모달 위에 전체 화면으로
        if rootViewController?.isDetailPaneVisible == true {
            topViewController?.dismiss(animated: false)
            rootViewController?.showDetail(questTipViewController)
            return
        }
        
        let navigationController = UINavigationController(rootViewController: questTipViewController)
        navigationController.modalPresentationStyle = .fullScreen
        topViewController?.present(navigationController, animated: false)
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
        questionQuestViewController.configureToWrite(questID, questNumber, questType, nil)
        rootViewController?.tabBarController?.tabBar.isHidden = true
        // 펼친 iPhone Duo에서는 목록 오른쪽에, 그 외에는 push
        rootViewController?.showDetail(questionQuestViewController)
    }
    
    private func moveToWriteActivity(questID: Int, questNumber: Int, questType: QuestType) {
        let activationQuestViewController = ViewControllerFactory.shared.makeWriteActiveTypeQuestViewController()
        activationQuestViewController.configure(questID, questNumber, questType, nil)
        rootViewController?.tabBarController?.tabBar.isHidden = true
        // 펼친 iPhone Duo에서는 목록 오른쪽에, 그 외에는 push
        rootViewController?.showDetail(activationQuestViewController)
    }
}
