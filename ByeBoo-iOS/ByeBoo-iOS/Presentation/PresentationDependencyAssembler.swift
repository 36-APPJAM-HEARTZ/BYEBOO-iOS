//
//  PresentationDependencyAssembler.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/30/25.
//

import Foundation

struct PresentationDependencyAssembler: DependencyAssembler {
    private let preAssembler: DependencyAssembler
    
    init(preAssembler: DependencyAssembler) {
        self.preAssembler = preAssembler
    }
    
    func assemble() {
        preAssembler.assemble()
        
        DIContainer.shared.register(type: JourneyResultViewModel.self) { container in
            guard let fetchUserUseCase = container.resolve(type: FetchUserJourneyUseCase.self),
                  let getNameUseCase = container.resolve(type: GetUserNameUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return JourneyResultViewModel(
                fetchUserJourneyUseCase: fetchUserUseCase,
                getUserNameUseCase: getNameUseCase
            )
        }
    }
}
