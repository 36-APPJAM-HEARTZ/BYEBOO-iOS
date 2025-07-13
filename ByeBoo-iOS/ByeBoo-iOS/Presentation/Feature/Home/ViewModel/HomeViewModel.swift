//
//  HomeViewModel.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/13/25.
//

import Combine
import Foundation

final class HomeViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var output: Output
    private var characterResultSubject = PassthroughSubject<Result<String, ByeBooError>, Never>()

    private let fetchCharacterDialogueUseCase: FetchCharacterDialogueUseCase
    
    init(
        fetchCharacterDialogueUseCase: FetchCharacterDialogueUseCase
    ) {
        self.fetchCharacterDialogueUseCase = fetchCharacterDialogueUseCase
        
        output = Output(
            characterResult: characterResultSubject.eraseToAnyPublisher()
        )
    }
}

extension HomeViewModel: ViewModelType {
    enum Input {
        case viewDidLoad
    }
    
    struct Output {
        let characterResult: AnyPublisher<Result<String, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchDialogue()
        }
    }
}

extension HomeViewModel {
    private func fetchDialogue() {
        Task {
            do {
                let dialogue = try await fetchCharacterDialogueUseCase.execute()
                characterResultSubject.send(.success(dialogue))
            } catch {
                characterResultSubject.send(
                    .failure(
                        error as? ByeBooError ?? ByeBooError.unknownError
                    )
                )
            }
        }
    }
}
