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
    private let readAllNotificationsUseCase: ReadAllNotificationsUseCase
    
    private(set) var output: Output
    private var notificationListSubject = PassthroughSubject<Result<NotificationListEntity, ByeBooError>, Never>()
    private var readAllNotificationsSubject = PassthroughSubject<Result<Void, ByeBooError>, Never>()
    
    init(
        fetchNotificationListUseCase: FetchNotificationListUseCase,
        formatElapsedTimeUseCase: FormatElapsedTimeUseCase,
        readNotificationUseCase: ReadNotificationUseCase,
        readAllNotificationsUseCase: ReadAllNotificationsUseCase
    ) {
        self.fetchNotificationListUseCase = fetchNotificationListUseCase
        self.formatElapsedTimeUseCase = formatElapsedTimeUseCase
        self.readNotificationUseCase = readNotificationUseCase
        self.readAllNotificationsUseCase = readAllNotificationsUseCase
        self.output = .init(
            notificationListResult: notificationListSubject.eraseToAnyPublisher(),
            readAllNotificationsResult: readAllNotificationsSubject.eraseToAnyPublisher()
        )
    }
}

extension NotificationsViewModel: ViewModelType {
    enum Input {
        case viewWillAppear
        case notificationDidTap(at: Int)
        case readAllNotificationsDidTap
    }
    
    struct Output {
        let notificationListResult: AnyPublisher<Result<NotificationListEntity, ByeBooError>, Never>
        let readAllNotificationsResult: AnyPublisher<Result<Void, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear:
            fetchNotificationList()
        case .notificationDidTap(let index):
            readNotification(at: index)
        case .readAllNotificationsDidTap:
            readAllNotifications()
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
        guard let notification = notifications?[index] else {
            return
        }
        
        if !notification.isRead {
            Task {
                do {
                    let _ = try await readNotificationUseCase.execute(for: notification.notificationID)
                } catch {
                    ByeBooLogger.error(error)
                }
            }
        }
        
        handleNotification(at: index)
    }
    
    func readAllNotifications() {
        guard let isAllRead = notifications?.allSatisfy({ $0.isRead }),
              !isAllRead
        else {
            return
        }
        
        Task {
            do {
                let _ = try await readAllNotificationsUseCase.execute()
                self.notifications = notifications?.map { $0.markAsRead() }
                readAllNotificationsSubject.send(.success(()))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                readAllNotificationsSubject.send(.failure(error))
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
    
    private func handleNotification(at index: Int) {
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
