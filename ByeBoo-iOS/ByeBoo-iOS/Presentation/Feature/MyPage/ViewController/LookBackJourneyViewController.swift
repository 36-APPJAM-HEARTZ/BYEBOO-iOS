//
//  LookBackJourneyViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import Combine
import UIKit

final class LookBackJourneyViewController: BaseViewController {
    
    private let rootView: LookBackJourneyView
    private let viewModel: LookBackJourneyViewModel
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = rootView
    }
    
    init(viewModel: LookBackJourneyViewModel) {
        self.viewModel = viewModel
        rootView = LookBackJourneyView(journeyList: [])
        super.init(nibName: nil, bundle: nil)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.action(.lookBackJourneyDidLoad)
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .back(),
            action: #selector(back)
        )
        
        bind()
    }
}

extension LookBackJourneyViewController: ToastPresentable, ToastErrorHandler {
    
    private func bind() {
        viewModel.output.lookBackJourneyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let entity):
                    self?.rootView.bind(with: entity)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
    }
}

extension LookBackJourneyViewController: BackNavigable {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
