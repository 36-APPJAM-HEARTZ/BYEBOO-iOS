//
//  CombineTestViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/1/25.
//

import Combine
import UIKit

final class CombineTestViewModel: ViewModelType {
    
    enum InputAction {
        case first
        case second
    }
    
    struct Input {
        let event: AnyPublisher<InputAction, Never>
    }
    
    struct Output {
        let result: AnyPublisher<Result<TestEntity, ByeBooError>, Never>
    }
    
    private var output: PassthroughSubject<Result<TestEntity, ByeBooError>, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private let testUseCase: TestUseCase
    
    init(testUseCase: TestUseCase) {
        self.testUseCase = testUseCase
    }
    
    func transform(input: Input) -> Output {
        input.event
            .sink { [weak self] action in
                switch action {
                case .first:
                    self?.fetchTestModel()
                case .second:
                    self?.fetchTestModel()
                }
            }
            .store(in: &cancellables)
        return Output(result: output.eraseToAnyPublisher())
    }
    
    private func fetchTestModel() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let name = try await testUseCase.testFetchUserName()
                output.send(.success(TestEntity(name: name, birth: "")))
            } catch {
                guard let error = error as? ByeBooError else { return }
                output.send(.failure(error))
            }
        }
    }
}
