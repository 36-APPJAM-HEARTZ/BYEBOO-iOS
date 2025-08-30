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
        setGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.action(.viewWillAppear)
    }
    
    override func setAddTarget() {
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
        guard tabBarController?.viewControllers?[safe: 1] != nil else { return }
        navigationController?.tabBarController?.selectedIndex = 1
    }
    
    @objc
    private func helperDidTap() {
        // TODO: 수정하기
        viewModel.action(.helperTapped)
        rootView.helperDidTap()
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
                    
                case (_, .failure(let error), _), (_, _, .failure(let error)):
                    self?.handleError(error)
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
