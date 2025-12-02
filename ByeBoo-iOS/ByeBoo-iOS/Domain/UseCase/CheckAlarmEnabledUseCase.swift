//
//  CheckAlarmEnabledUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 12/2/25.
//

protocol CheckAlarmEnabledUseCase {
    func execute() -> Bool
}

struct DefaultCheckAlarmEnabledUseCase: CheckAlarmEnabledUseCase {
    
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() -> Bool {
        repository.alarmEnabled
    }
}
