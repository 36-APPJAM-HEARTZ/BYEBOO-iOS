//
//  NotificationsViewModel.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/7/26.
//

final class NotificationsViewModel {
    
    private let formatElapsedTimeUseCase: FormatElapsedTimeUseCase
    
    init(formatElapsedTimeUseCase: FormatElapsedTimeUseCase) {
        self.formatElapsedTimeUseCase = formatElapsedTimeUseCase
    }
    
    func formatElapsedTime(from timeString: String) -> String? {
        formatElapsedTimeUseCase.execute(from: timeString)
    }
}
