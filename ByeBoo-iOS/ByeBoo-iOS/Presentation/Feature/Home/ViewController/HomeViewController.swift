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
import Mixpanel

final class HomeViewController: BaseViewController {
    
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    private let rootView = HomeView()
    
    private var state: HomeState = .beforeJourneyStart
    private var isFirstVisit: Bool = true
    private var journeyType: JourneyType = .face
    
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
        
        let property = HomeEvents.HomePageProperty(
            isFirstPageView: isFirstVisit,
            journeyType: journeyType.mixpanelKey
        )
        Mixpanel.mainInstance().track(
            event: HomeEvents.Name.homePageView,
            properties: property.dictionary
        )
        
        if isFirstVisit { isFirstVisit.toggle() }
    }
    
    override func setAddTarget() {
        setGesture()
        rootView.headerView.helperButton.addTarget(self, action: #selector(helperDidTap), for: .touchUpInside)
    }
    
    private func setGesture() {
        let headerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headerDidTap))
        headerTapGestureRecognizer.isEnabled = true
        headerTapGestureRecognizer.cancelsTouchesInView = false
        rootView.headerView.homeStateView.addGestureRecognizer(headerTapGestureRecognizer)
        
        let boriTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(boriDidTap))
        boriTapGestureRecognizer.isEnabled = true
        boriTapGestureRecognizer.cancelsTouchesInView = false
        rootView.homeBori.addGestureRecognizer(boriTapGestureRecognizer)
    }
}

extension HomeViewController {
    @objc
    private func headerDidTap() {
        switch state {
        case .beforeJourneyStart, .beforeQuest, .afterQuest:
            ViewControllerUtils.changeSelectedIndex(index: 1)
        case .afterJourney:
            let viewController = ViewControllerFactory.shared.makeNewJourneySelectViewController()
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    @objc
    private func helperDidTap() {
        viewModel.action(.helperTapped)
        rootView.helperDidTap()
        
        Mixpanel.mainInstance().track(event: HomeEvents.Name.tutorialIconClick)
        
        let tutorialViewController = TutorialModalViewController()
        tutorialViewController.navigationItem.hidesBackButton = true
        tutorialViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(tutorialViewController, animated: false)
    }
    
    @objc
    private func boriDidTap() {
        guard case .success(let dialogues) = viewModel.dialoguesResult else { return }

        self.rootView.updateOnboardingText(dialogues.tapDialogue)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.rootView.updateOnboardingText(dialogues.dialogue)
        }
    }
}

extension HomeViewController: ToastPresentable, ToastErrorHandler {
    private func bind() {
        viewModel.output.characterResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let dialogues):
                    self?.rootView.updateOnboardingText(dialogues.dialogue)
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
                    self?.journeyType = JourneyType.titleToEnum(journey.title) ?? .face
                case let (_, .success(journey), .failure(.notFoundQuest)):
                    self?.rootView.updateState(.beforeJourneyStart, journey.title)
                    self?.state = .beforeJourneyStart
                    self?.journeyType = JourneyType.titleToEnum(journey.title) ?? .face
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
