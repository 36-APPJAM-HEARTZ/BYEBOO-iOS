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
    func makeLookBackViewController() -> LookBackJourneyViewController
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
        guard let viewModel = DIContainer.shared.resolve(type: QuestsViewModel.self) else {
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
    
    func makeLookBackViewController() -> LookBackJourneyViewController {
        guard let viewModel = DIContainer.shared.resolve(type: LookBackJourneyViewModel.self) else {
            DIErrorHandle()
            fatalError()
        }
        return LookBackJourneyViewController(viewModel: viewModel)
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
    //TODO: Login으로 변경
    private func DIErrorHandle() {
        ByeBooLogger.error(ByeBooError.DIFailedError)
        
        let tempViewController = OnboardingViewController()
        
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
