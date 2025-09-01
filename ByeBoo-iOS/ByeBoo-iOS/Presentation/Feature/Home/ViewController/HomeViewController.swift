//
//  HomeViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/5/25.
//

import Combine
import UIKit

import SnapKit
import Then

final class HomeViewController: BaseViewController {
    
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    private let rootView = HomeView()
    
    private var state: HomeState = .beforeJourneyStart
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.action(.viewWillAppear)
    }
    
    override func setAddTarget() {
        setGesture()
        rootView.headerView.helperButton.addTarget(self, action: #selector(helperDidTap), for: .touchUpInside)
    }
    
    private func setGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headerDidTap))
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.cancelsTouchesInView = false
        rootView.headerView.homeStateView.addGestureRecognizer(tapGestureRecognizer)
    }
}

extension HomeViewController {
    @objc
    private func headerDidTap() {
        switch state {
        case .beforeJourneyStart, .beforeQuest, .afterQuest:
            guard tabBarController?.viewControllers?[safe: 1] != nil else { return }
            navigationController?.tabBarController?.selectedIndex = 1
        case .afterJourney:
            let viewController = ViewControllerFactory.shared.makeNewJourneySelectViewController()
            navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    @objc
    private func helperDidTap() {
        viewModel.action(.helperTapped)
        rootView.helperDidTap()
        
        let tutorialViewController = TutorialModalViewController()
        tutorialViewController.navigationItem.hidesBackButton = true
        tutorialViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(tutorialViewController, animated: false)
    }
}

extension HomeViewController: ToastPresentable, ToastErrorHandler {
    private func bind() {
        viewModel.output.characterResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let text):
                    self?.rootView.updateOnboardingText(text)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
  
        Publishers.CombineLatest3(
            viewModel.output.userResult,
            viewModel.output.journeyResult,
            viewModel.output.homeStateResult
        )
            .receive(on: DispatchQueue.main)
            .sink { [weak self]
                name,
                journey,
                state in
                switch (name, journey, state) {
                case let (name, .success(journey), .success(state)):
                    self?.rootView.updateState(state.currentStatus)
                    self?.state = state.currentStatus
                    self?.rootView.updateProgressView(
                        name: name,
                        progress: state.questCount,
                        journey: journey.title
                    )
                    
                case let (_, .success(journey), .failure(.notFoundQuest)):
                    self?.rootView.updateState(.beforeJourneyStart, journey.title)
                    self?.state = .beforeJourneyStart
                case let (_, .failure(.notFoundQuest), .success(state)):
                    self?.rootView.updateState(state.currentStatus)
                    self?.state = state.currentStatus
                case (_, .failure(let error), _), (_, _, .failure(let error)):
                    self?.handleError(error)
                default:
                    ByeBooLogger.error(ByeBooError.unknownError)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.helperResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                if !result {
                    self?.rootView.headerView.startHelperAnimation()
                }
            }
            .store(in: &cancellables)
    }
}
