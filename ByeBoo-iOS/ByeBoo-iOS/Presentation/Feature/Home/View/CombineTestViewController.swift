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
    private let input = PassthroughSubject<CombineTestViewModel.InputAction, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CombineTestViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataBind()
        // 테스트용으로 명시한 것으로, 실제 앱에서는 input은 버튼 클릭 등 사용자 액션에서 전달됩니다.
        input.send(.first)
        input.send(.second)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dataBind() {
        let output = viewModel.transform(
            input: CombineTestViewModel.Input(event: input.eraseToAnyPublisher())
        )
        
        output.result
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
