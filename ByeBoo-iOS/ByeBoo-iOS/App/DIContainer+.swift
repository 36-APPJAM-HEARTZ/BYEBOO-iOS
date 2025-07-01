//
//  DependencyInjection.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/30/25.
//

extension DIContainer {
    /// assemble 하는 순서는 data의 repository -> domain의 useCase -> presentation의 viewmodel
    func dependencyInject() {
        let dataAssembler = DataDependencyAssembler()
        let domainAssembler = DomainDependencyAssembler(preAssembler: dataAssembler)
        let presentationAssembler = PresentationDependencyAssembler(preAssembler: domainAssembler)
        presentationAssembler.assemble()
    }
}
