//
//  JourneyResultViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit
import Combine

final class JourneyResultViewController: BaseViewController {
    
    private let viewModel: JourneyResultViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let rootView = JourneyResultView()
    
    init(viewModel: JourneyResultViewModel) {
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
        
        viewModel.action(.viewDidLoad)
    }

    override func setAddTarget() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(confirmLabelDidTap))
        rootView.confirmLabel.addGestureRecognizer(tapRecognizer)
        rootView.confirmLabel.isUserInteractionEnabled = true
    }
}

extension JourneyResultViewController {
    @objc
    private func confirmLabelDidTap() {
        let viewController = HomeOnboardingViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    private func bind() {
        viewModel.output.journeyResult
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success(let journey):
                    self.rootView.updateJourney(
                        journeyType: JourneyType(rawValue: journey.title) ?? .face,
                        journeyDescription: journey.description ?? ""
                    )
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
                    self.rootView.updateName(name: name)
                case .failure(let failure):
                    ByeBooLogger.error(failure)
                }
            }
            .store(in: &cancellables)
    }
}
