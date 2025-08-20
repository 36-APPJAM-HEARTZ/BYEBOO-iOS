//
//  NewJourneySelectViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import Combine
import UIKit

final class NewJourneySelectViewController: BaseViewController {
    
    private let rootView: NewJourneySelectView
    private let viewModel: NewJourneyViewModel
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = rootView
    }

    init(viewModel: NewJourneyViewModel) {
        self.viewModel = viewModel
        rootView = NewJourneySelectView(unCompleteJourneyList: [], completeJourneyList: [])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.action(.newJourneyDidLoad)
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .back(),
            action: #selector(back)
        )
        
        bind()
    }
    
    private func bind() {
        viewModel.output.newJourneyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let entity):
                    self?.rootView.bind(with: entity)
                case .failure(let error):
                    ByeBooLogger.debug(error)
                }
            }
            .store(in: &cancellables)
    }
}

extension NewJourneySelectViewController: BackNavigable {
    func back() {
        guard let navigationController else {
            ByeBooLogger.error(ByeBooError.navigationControllerMissing)
            return
        }
        
        navigationController.popViewController(animated: true)
    }
}
