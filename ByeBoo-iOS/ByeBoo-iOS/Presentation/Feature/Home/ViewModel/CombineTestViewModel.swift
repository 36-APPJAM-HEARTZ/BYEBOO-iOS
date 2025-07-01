//
//  CombineTestViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/1/25.
//

import Combine
import UIKit

final class CombineTestViewModel: ViewModelType {
    
    struct Input {
        let publisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let result: AnyPublisher<Result<TestViewModel, ByeBooError>, Never>
    }
    
    private var output: PassthroughSubject<Result<TestViewModel, ByeBooError>, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private let testuseCase: TestUseCase
    
    init(testUseCase: TestUseCase) {
        self.testuseCase = testUseCase
    }
    
    func transform(input: Input) -> Output {
        input.publisher
            .sink { [weak self] _ in
                self?.fetchTestModel()
            }
            .store(in: &cancellables)
        return Output(result: output.eraseToAnyPublisher())
    }
    
    private func fetchTestModel() {
//        testuseCase.testFetchModel()
//            .sink(receiveCompletion: { [weak self] completion in
//                if case .failure(let error) = completion {
//                    self?.output.send(.failure(error))
//                }
//            }, receiveValue: { [weak self] model in
//                self?.output.send(.success(model))
//            })
//            .store(in: &cancellables)
    }
}
