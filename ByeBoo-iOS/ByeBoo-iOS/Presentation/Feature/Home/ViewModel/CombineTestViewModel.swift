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
    
    struct Output {
        let result: AnyPublisher<Result<TestEntity, ByeBooError>, Never>
    }
    
    private var resultSubject: PassthroughSubject<Result<TestEntity, ByeBooError>, Never> = .init()
    var result: AnyPublisher<Result<TestEntity, ByeBooError>, Never> {
        resultSubject.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
    private let testUseCase: TestUseCase
    
    init(testUseCase: TestUseCase) {
        self.testUseCase = testUseCase
    }
    
    func action(_ trigger: InputAction) {
        switch trigger {
        case .first, .second:
            fetchTestModel()
        }
    }
    
    private func fetchTestModel() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let name = try await testUseCase.testFetchUserName()
                resultSubject.send(.success(TestEntity(name: name, birth: "")))
            } catch {
                guard let error = error as? ByeBooError else { return }
                resultSubject.send(.failure(error))
            }
        }
    }
}
