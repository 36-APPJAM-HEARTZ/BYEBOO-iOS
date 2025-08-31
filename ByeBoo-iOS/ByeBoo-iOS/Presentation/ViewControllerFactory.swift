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
