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
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CombineTestViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataBind()
        viewModel.action(.first)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dataBind() {
        viewModel.result
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let entity):
                    self?.updateUI(from: entity)
                case .failure(let error):
                    ByeBooLogger.network(error)
                }
            }
            .store(in: &cancellables)
    }
    
    func updateUI(from entity: TestEntity) {
        
    }
}
