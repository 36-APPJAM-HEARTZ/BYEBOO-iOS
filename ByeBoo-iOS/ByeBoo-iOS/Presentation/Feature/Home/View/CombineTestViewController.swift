//
//  CombineTestViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/1/25.
//

import Combine
import UIKit

final class CombineTestViewController: UIViewController {
    
    private let viewModel: CombineTestViewModel
    private let input = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CombineTestViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dataBind() {
        let output = viewModel.transform(
            input: CombineTestViewModel.Input(publisher: input.eraseToAnyPublisher())
        )
        
        output.result
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let model):
                    self?.updateUI(model: model)
                case .failure(let error):
                    ByeBooLogger.network(error)
                }
            }
            .store(in: &cancellables)
    }
    
    func updateUI(model: TestViewModel) {
        
    }
}
