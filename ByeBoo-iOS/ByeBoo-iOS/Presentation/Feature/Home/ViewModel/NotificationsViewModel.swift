//
//  NotificationsViewModel.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/7/26.
//

import Combine

final class NotificationsViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    private var notifications: [NotificationEntity]?
    
    private let fetchNotificationListUseCase: FetchNotificationListUseCase
    private let formatElapsedTimeUseCase: FormatElapsedTimeUseCase
    private let readNotificationUseCase: ReadNotificationUseCase
    private(set) var notificationList: NotificationListEntity?
    
    private(set) var output: Output
    private var notificationListSubject = PassthroughSubject<Result<NotificationListEntity, ByeBooError>, Never>()
    
    init(
        fetchNotificationListUseCase: FetchNotificationListUseCase,
        formatElapsedTimeUseCase: FormatElapsedTimeUseCase
    ) {
        self.fetchNotificationListUseCase = fetchNotificationListUseCase
        self.formatElapsedTimeUseCase = formatElapsedTimeUseCase
        self.output = .init(notificationList: notificationListSubject.eraseToAnyPublisher())
    }
}

extension NotificationsViewModel: ViewModelType {
    enum Input {
        case viewWillAppear
    }
    
    struct Output {
        let notificationList: AnyPublisher<Result<NotificationListEntity, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear:
            fetchNotificationList()
        }
    }
    
    func readNotification(at index: Int) {
        guard let notificationID = notificationList?.notifications[index].notificationID else {
            return
        }
        
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

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            destination.navigate(from: window)
        }
    }
    
    private func getLandingURL(at index: Int) -> String? {
        notificationList?.notifications[index].landingURL
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
}

extension NotificationsViewModel {
    
    var notificatinosCount: Int {
        notifications?.count ?? 0
    }
    
    func getNotification(at index: Int) -> NotificationEntity? {
        notifications?[index]
    }
}
