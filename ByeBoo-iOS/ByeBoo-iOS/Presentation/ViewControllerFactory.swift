//
//  ViewControllerFactory.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 8/23/25.
//

import UIKit

protocol ViewControllerFactoryProtocol {
    func makeHomeViewController() -> HomeViewController
    func makeMyPageViewController() -> MyPageViewController
    func makeQuestViewController() -> QuestCheckViewController
    func makeInformationViewController() -> InformationViewController
    func makeCardJourneyViewController() -> CardJourneyViewController
    func makeQuestStartViewController() -> QuestStartViewController
    func makeLookBackJourneyViewController() -> LookBackJourneyViewController
    func makeNewJourneySelectViewController() -> NewJourneySelectViewController
    func makeLoginViewController() -> LoginViewController
    func makeModifyNicknameViewController() -> ModifyNicknameViewController
    func makeTermsViewController() -> TermsViewController
    func makeSplashViewController() -> SplashViewController
    func makeArchiveQuestViewController() -> ArchiveQuestViewController
    func makeQuestTipViewController() -> QuestTipViewController
    func makeWriteQuestionTypeQuestViewController() -> WriteQuestionTypeQuestViewController
    func makeWriteActiveTypeQuestViewController() -> WriteActiveTypeQuestViewController
    func makeCompleteActiveTypeQuestViewController() -> CompleteActiveTypeQuestViewController
    func makeCompleteQuestionTypeQuestViewController() -> CompleteQuestionTypeQuestViewController
    func makeFinishJourneyViewController() -> FinishJourneyViewController
}

final class ViewControllerFactory: ViewControllerFactoryProtocol {
    static let shared = ViewControllerFactory()
    private init() { }
    
    func makeHomeViewController() -> HomeViewController {
        guard let viewModel = DIContainer.shared.resolve(type: HomeViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return HomeViewController(viewModel: viewModel)
    }
    
    func makeMyPageViewController() -> MyPageViewController {
        guard let viewModel = DIContainer.shared.resolve(type: MyPageViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return MyPageViewController(viewModel: viewModel)
    }
    
    func makeQuestViewController() -> QuestCheckViewController {
        guard let viewModel = DIContainer.shared.resolve(type: ProgressingQuestsViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return QuestCheckViewController(viewModel: viewModel)
    }
    
    func makeInformationViewController() -> InformationViewController {
        guard let viewModel = DIContainer.shared.resolve(type: InformationViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return InformationViewController(viewModel: viewModel)
    }
    
    func makeCardJourneyViewController() -> CardJourneyViewController {
        guard let viewModel = DIContainer.shared.resolve(type: JourneyResultViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return CardJourneyViewController(viewModel: viewModel)
    }
    
    func makeQuestStartViewController() -> QuestStartViewController {
        guard let viewModel = DIContainer.shared.resolve(type: QuestStartViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return QuestStartViewController(viewModel: viewModel)
    }
    
    func makeLookBackJourneyViewController() -> LookBackJourneyViewController {
        guard let viewModel = DIContainer.shared.resolve(type: LookBackJourneyViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return LookBackJourneyViewController(viewModel: viewModel)
    }
    
    func makeNewJourneySelectViewController() -> NewJourneySelectViewController {
        guard let viewModel = DIContainer.shared.resolve(type: NewJourneyViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return NewJourneySelectViewController(viewModel: viewModel)
    }
    
    func makeLoginViewController() -> LoginViewController {
        guard let viewModel = DIContainer.shared.resolve(type: LoginViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return LoginViewController(viewModel: viewModel)
    }
    
    func makeModifyNicknameViewController() -> ModifyNicknameViewController {
        guard let viewModel = DIContainer.shared.resolve(type: ModifyNicknameViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return ModifyNicknameViewController(viewModel: viewModel)
    }
    
    func makeTermsViewController() -> TermsViewController {
        return TermsViewController()
    }
    
    func makeSplashViewController() -> SplashViewController {
        guard let viewModel = DIContainer.shared.resolve(type: SplashViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return SplashViewController(viewModel: viewModel)
    }
    
    func makeArchiveQuestViewController() -> ArchiveQuestViewController {
        guard let viewModel = DIContainer.shared.resolve(type: CompleteQuestViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return ArchiveQuestViewController(viewModel: viewModel)
    }
    
    func makeQuestTipViewController() -> QuestTipViewController {
        guard let viewModel = DIContainer.shared.resolve(type: QuestTipViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return QuestTipViewController(viewModel: viewModel)
    }
    
    func makeWriteQuestionTypeQuestViewController() -> WriteQuestionTypeQuestViewController {
        guard let viewModel = DIContainer.shared.resolve(type: WriteQuestionTypeViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return WriteQuestionTypeQuestViewController(viewModel: viewModel)
    }
    
    func makeWriteActiveTypeQuestViewController() -> WriteActiveTypeQuestViewController {
        guard let viewModel = DIContainer.shared.resolve(type: WriteActiveTypeViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return WriteActiveTypeQuestViewController(viewModel: viewModel)
    }
    
    func makeCompleteActiveTypeQuestViewController() -> CompleteActiveTypeQuestViewController {
        guard let viewModel = DIContainer.shared.resolve(type: CompleteQuestViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return CompleteActiveTypeQuestViewController(viewModel: viewModel)
    }
    
    func makeCompleteQuestionTypeQuestViewController() -> CompleteQuestionTypeQuestViewController {
        guard let viewModel = DIContainer.shared.resolve(type: CompleteQuestViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return CompleteQuestionTypeQuestViewController(viewModel: viewModel)
    }
    
    func makeFinishJourneyViewController() -> FinishJourneyViewController {
        
        guard let viewModel = DIContainer.shared.resolve(type: FinishJourneyViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return FinishJourneyViewController(viewModel: viewModel)
    }
    
    func makeCompletedQuestsViewController() -> CompletedQuestsViewController {
        guard let viewModel = DIContainer.shared.resolve(type: CompletedQuestsViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return CompletedQuestsViewController(viewModel: viewModel)
    }
    
    func makeParentQuestViewController() -> ParentQuestViewController<QuestTabItem> {
        return ParentQuestViewController(items: QuestTabItem.allCases)
    }
    
    func makeCommonQuestViewController() -> CommonQuestViewController {
        guard let viewModel = DIContainer.shared.resolve(type: CommonQuestViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        
        return .init(viewModel: viewModel)
    }
    
    func makeCommonQuestHistoryViewController() -> CommonQuestHistoryViewController {
        .init()
    }
    
    func makeCommonQuestMyAnswersViewController() -> CommonQuestMyAnswersViewController {
        guard let viewModel = DIContainer.shared.resolve(type: CommonQuestMyAnswerViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        
        return .init(viewModel: viewModel)
    }
}

extension ViewControllerFactory {
    private func DIErrorHandle() {
        ByeBooLogger.error(ByeBooError.DIFailedError)
        
        let tempViewController = ViewControllerFactory.shared.makeLoginViewController()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            ViewControllerUtils.setRootViewController(
                window: window,
                viewController: tempViewController,
                withAnimation: true
            )
        }
    }
}
