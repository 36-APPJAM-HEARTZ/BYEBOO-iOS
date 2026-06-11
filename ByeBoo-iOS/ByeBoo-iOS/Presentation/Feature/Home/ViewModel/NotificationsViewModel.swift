//
//  NotificationsViewModel.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/7/26.
//

import Combine

final class NotificationsViewModel: ViewModelType {
    
    private let formatElapsedTimeUseCase: FormatElapsedTimeUseCase
    private let readNotificationUseCase: ReadNotificationUseCase
    
    private var cancellables: Set<AnyCancellable> = .init()
    private var formatElapsedTimeSubject: PassthroughSubject<Result<String, ByeBooError>, Never> = .init()
    private var readNotificationSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private(set) var output: Output
    
    init(
        formatElapsedTimeUseCase: FormatElapsedTimeUseCase,
        readNotificationUseCase: ReadNotificationUseCase
    ) {
        self.formatElapsedTimeUseCase = formatElapsedTimeUseCase
        self.readNotificationUseCase = readNotificationUseCase
        self.output = Output(
            formattedTimeResult: formatElapsedTimeSubject.eraseToAnyPublisher(),
            readNotificationResult: readNotificationSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .dequeueCell(let rawTime):
            formatElapsedTime(from: rawTime)
        case .notificationDidTap(let notificationID):
            readNotification(for: notificationID)
        }
    }
}

extension NotificationsViewModel {
    
    enum Input {
        case dequeueCell(rawTime: String)
        case notificationDidTap(notificationID: Int)
    }
    
    struct Output {
        let formattedTimeResult: AnyPublisher<Result<String,ByeBooError>, Never>
        let readNotificationResult: AnyPublisher<Result<Void, ByeBooError>, Never>
    }
}

extension NotificationsViewModel {
    
    func formatElapsedTime(from timeString: String) {
        guard let formattedTime = formatElapsedTimeUseCase.execute(from: timeString) else {
            formatElapsedTimeSubject.send(.failure(.dateFormatError))
            return
        }
        
        formatElapsedTimeSubject.send(.success(formattedTime))
    }
    
    func readNotification(for notificationID: Int) {
        Task {
            do {
                try await readNotificationUseCase.execute(for: notificationID)
                readNotificationSubject.send(.success(()))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                readNotificationSubject.send(.failure(error))
            }
        }
    }
}
