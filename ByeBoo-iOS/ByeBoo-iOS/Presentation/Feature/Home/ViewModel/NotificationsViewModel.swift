//
//  NotificationsViewModel.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/7/26.
//

import Combine
import UIKit

final class NotificationsViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    private var notifications: [NotificationEntity]?
    
    private let fetchNotificationListUseCase: FetchNotificationListUseCase
    private let formatElapsedTimeUseCase: FormatElapsedTimeUseCase
    private let readNotificationUseCase: ReadNotificationUseCase
    
    private(set) var output: Output
    private var notificationListSubject = PassthroughSubject<Result<NotificationListEntity, ByeBooError>, Never>()
    
    init(
        fetchNotificationListUseCase: FetchNotificationListUseCase,
        formatElapsedTimeUseCase: FormatElapsedTimeUseCase,
        readNotificationUseCase: ReadNotificationUseCase
    ) {
        self.fetchNotificationListUseCase = fetchNotificationListUseCase
        self.formatElapsedTimeUseCase = formatElapsedTimeUseCase
        self.readNotificationUseCase = readNotificationUseCase
        self.output = .init(notificationListResult: notificationListSubject.eraseToAnyPublisher())
    }
}

extension NotificationsViewModel: ViewModelType {
    enum Input {
        case viewWillAppear
        case notificationDidTap(at: Int)
    }
    
    struct Output {
        let notificationListResult: AnyPublisher<Result<NotificationListEntity, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear:
            fetchNotificationList()
        case .notificationDidTap(let index):
            readNotification(at: index)
        }
    }
}

extension NotificationsViewModel {
    
    func fetchNotificationList() {
        Task {
            do {
                let notificationList = try await fetchNotificationListUseCase.execute()
                self.notifications = notificationList.notifications
                notificationListSubject.send(.success(notificationList))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                notificationListSubject.send(.failure(error))
            }
        }
    }
    
    func formatElapsedTime(from timeString: String) -> String? {
        formatElapsedTimeUseCase.execute(from: timeString)
    }
    
    func readNotification(at index: Int) {
        guard let notification = notifications?[index],
              !notification.isRead
        else {
            return
        }
        
        Task {
            do {
                let _ = try await readNotificationUseCase.execute(for: notification.notificationID)
            } catch {
                ByeBooLogger.error(error)
            }
        }
    }
}

extension NotificationsViewModel {
    
    var notificatinosCount: Int {
        notifications?.count ?? 0
    }
    
    func getNotification(at index: Int) -> NotificationEntity? {
        guard let notifications,
              notifications.indices.contains(index)
        else {
            return nil
        }
        
        return notifications[index]
    }
    
    func handleNotification(at index: Int) {
        guard let landingURL = getLandingURL(at: index),
              let destination = DeepLinkParser.parse(from: landingURL)
        else {
            return
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            destination.navigate(from: window)
        }
    }
    
    private func getLandingURL(at index: Int) -> String? {
        let notification = getNotification(at: index)
        return notification?.landingURL
    }
}
