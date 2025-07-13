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
    
    private var state: HomeState = .beforeJourneyStart(journey: .stub())
    
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
        setGesture()
        
        viewModel.action(.viewDidLoad)
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
        case .beforeJourneyStart:
            let viewController = QuestStartViewController()
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.hidesBackButton = true
            navigationController?.pushViewController(viewController, animated: false)
        case .beforeQuest:
            navigationController?.tabBarController?.selectedIndex = 1
        case .afterJourney, .afterQuest:
            break
        }
    }
}

extension HomeViewController {
    private func bind() {
        viewModel.output.characterResult
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success(let text):
                    self.rootView.updateOnboardingText(text)
                case .failure(let failure):
                    ByeBooLogger.error(failure)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.countResult
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success(let count):
                    self.rootView.updateProgress(count)
                    self.state = .beforeQuest
                case .failure(let failure):
                    ByeBooLogger.error(failure)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.userResult
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success(let name):
                    self.rootView.updateName(name)
                case .failure(let failure):
                    ByeBooLogger.error(failure)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.homeStateResult
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success(let state):
                    self.rootView.updateState(state)
                case .failure(let failure):
                    ByeBooLogger.error(failure)
                }
            }
            .store(in: &cancellables)
    }
}
