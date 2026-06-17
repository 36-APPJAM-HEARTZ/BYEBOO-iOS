//
//  NotificationsViewModel.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/7/26.
//

import Combine
import UIKit

final class NotificationsViewModel: ViewModelType {
    
    private let fetchNotificationListUseCase: FetchNotificationListUseCase
    private let formatElapsedTimeUseCase: FormatElapsedTimeUseCase
    private let readNotificationUseCase: ReadNotificationUseCase
    private(set) var notificationList: NotificationListEntity?
    
    private var cancellables: Set<AnyCancellable> = .init()
    private(set) var output: Output

    private var notificationResultSubject = PassthroughSubject<Result<NotificationListEntity, ByeBooError>, Never>()
    private var formatElapsedTimeSubject: PassthroughSubject<Result<String, ByeBooError>, Never> = .init()
    private var readNotificationSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    
    init(
        fetchNotificationListUseCase: FetchNotificationListUseCase,
        formatElapsedTimeUseCase: FormatElapsedTimeUseCase,
        readNotificationUseCase: ReadNotificationUseCase
    ) {
        self.fetchNotificationListUseCase = fetchNotificationListUseCase
        self.formatElapsedTimeUseCase = formatElapsedTimeUseCase
        self.readNotificationUseCase = readNotificationUseCase
        self.output = Output(
            notificationListResult: notificationResultSubject.eraseToAnyPublisher(),
            formattedTimeResult: formatElapsedTimeSubject.eraseToAnyPublisher(),
            readNotificationResult: readNotificationSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear:
            fetchNotificationList()
        case .dequeueCell(let rawTime):
            formatElapsedTime(from: rawTime)
        case .notificationDidTap(let notificationID):
            readNotification(for: notificationID)
        }
    }
}

extension NotificationsViewModel {
    
    enum Input {
        case viewWillAppear
        case dequeueCell(rawTime: String)
        case notificationDidTap(notificationID: Int)
    }
    
    struct Output {
        let notificationListResult: AnyPublisher<Result<NotificationListEntity, ByeBooError>, Never>
        let formattedTimeResult: AnyPublisher<Result<String,ByeBooError>, Never>
        let readNotificationResult: AnyPublisher<Result<Void, ByeBooError>, Never>
    }
}

extension NotificationsViewModel {
    
    func fetchNotificationList() {
        Task {
            do {
                let notificationList = try await fetchNotificationListUseCase.execute()
                self.notificationList = NotificationListEntity.stub()
                notificationResultSubject.send(.success(NotificationListEntity.stub()))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                notificationResultSubject.send(.failure(error))
            }
        }
    }
    
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
    
    func move(from rootViewController: UIViewController, at index: Int) {
        guard let landingURL = getLandingURL(at: index),
              let destination = DeepLinkParser.parse(from: landingURL)
        else {
            return
        }
        
        let coordinator = DeepLinkCoordinator(rootViewController: rootViewController)
        coordinator.navigate(to: destination)
    }
    
    private func getLandingURL(at index: Int) -> String? {
        notificationList?.notifications[index].landingURL
    }
}
