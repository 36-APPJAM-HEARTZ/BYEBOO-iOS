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
    
    var dialoguesResult: Result<DialogueEntity, ByeBooError> {
        characterResultSubject.value
    }
    private(set) var notifications: NotificationListEntity?
    
    private(set) var output: Output
    private var characterResultSubject = CurrentValueSubject<Result<DialogueEntity, ByeBooError>, Never>(.failure(ByeBooError.noData))
    private var userResultSubject = CurrentValueSubject<String, Never>("하츠핑")
    private var isHelperShownResultSubject = CurrentValueSubject<Bool, Never>(true)
    private var homeStateResultSubject = PassthroughSubject<Result<UserQuestStatusEntity, ByeBooError>, Never>()
    private var journeyResultSubject = PassthroughSubject<Result<JourneyEntity, ByeBooError>, Never>()
    private var notificationResultSubject = PassthroughSubject<Result<NotificationListEntity, ByeBooError>, Never>()
    
    private let fetchCharacterDialogueUseCase: FetchCharacterDialogueUseCase
    private let fetchQuestStatusUseCase: FetchQuestStatusUseCase
    private let fetchUserJourneyUseCase: FetchUserJourneyUseCase
    private let getUserNameUseCase: GetUserNameUseCase
    private let setHelperUseCase: SetHelperUseCase
    private let getHelperUseCase: GetHelperUseCase
    private let fetchNotificationListUseCase: FetchNotificationListUseCase
    
    init(
        fetchCharacterDialogueUseCase: FetchCharacterDialogueUseCase,
        fetchQuestStatusUseCase: FetchQuestStatusUseCase,
        fetchUserJourneyUseCase: FetchUserJourneyUseCase,
        getUserNameUseCase: GetUserNameUseCase,
        setHelperUseCase: SetHelperUseCase,
        getHelperUseCase: GetHelperUseCase,
        fetchNotificationListUseCase: FetchNotificationListUseCase
    ) {
        self.fetchCharacterDialogueUseCase = fetchCharacterDialogueUseCase
        self.fetchQuestStatusUseCase = fetchQuestStatusUseCase
        self.fetchUserJourneyUseCase = fetchUserJourneyUseCase
        self.getUserNameUseCase = getUserNameUseCase
        self.setHelperUseCase = setHelperUseCase
        self.getHelperUseCase = getHelperUseCase
        self.fetchNotificationListUseCase = fetchNotificationListUseCase
        
        output = Output(
            characterResult: characterResultSubject.eraseToAnyPublisher(),
            userResult: userResultSubject.eraseToAnyPublisher(),
            helperResult: isHelperShownResultSubject.eraseToAnyPublisher(),
            homeStateResult: homeStateResultSubject.eraseToAnyPublisher(),
            journeyResult: journeyResultSubject.eraseToAnyPublisher(),
            notificationResult: notificationResultSubject.eraseToAnyPublisher()
        )
    }
}

extension HomeViewModel: ViewModelType {
    enum Input {
        case viewWillAppear
        case helperDidTap
    }
    
    struct Output {
        let characterResult: AnyPublisher<Result<DialogueEntity, ByeBooError>, Never>
        let userResult: AnyPublisher<String, Never>
        let helperResult: AnyPublisher<Bool, Never>
        let homeStateResult: AnyPublisher<Result<UserQuestStatusEntity, ByeBooError>, Never>
        let journeyResult: AnyPublisher<Result<JourneyEntity, ByeBooError>, Never>
        let notificationResult: AnyPublisher<Result<NotificationListEntity, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear:
            getUserResult()
            
            Task {
                async let dialogue: Void = fetchDialogue()
                async let status: Void = fetchStatus()
                async let journey: Void = fetchJourney()
                async let notificationList: Void = fetchNotificationList()
                
                let _ = await (dialogue, status, journey, notificationList)
            }
            
        case .helperDidTap:
            setHelperShown()
        }
    }
}

extension HomeViewModel {
    private func fetchDialogue() async {
        do {
            let dialogues = try await fetchCharacterDialogueUseCase.execute()
            characterResultSubject.send(.success(dialogues))
        } catch {
            characterResultSubject.send(
                .failure(
                    error as? ByeBooError ?? ByeBooError.unknownError
                )
            )
        }
    }
    
    private func fetchStatus() async {
        do {
            let status = try await fetchQuestStatusUseCase.execute()
            homeStateResultSubject.send(.success(status))
            isHelperShown(state: status.currentStatus)
            ByeBooLogger.debug("home status: \(status)")
        } catch {
            if let error = error as? ByeBooError {
                homeStateResultSubject.send(.failure(error))
            }
            isHelperShown(state: .beforeJourneyStart)
        }
    }
    
    private func fetchJourney() async {
        do {
            let journey = try await fetchUserJourneyUseCase.execute()
            journeyResultSubject.send(.success(journey))
        } catch {
            journeyResultSubject.send(
                .failure(
                    error as? ByeBooError ?? ByeBooError.unknownError
                )
            )
        }
    }
    
    private func getUserResult() {
        let name = getUserNameUseCase.execute()
        userResultSubject.send(name)
    }
    
    private func isHelperShown(state: HomeState) {
        if !getHelperUseCase.execute() && state == .beforeJourneyStart {
            isHelperShownResultSubject.send(false)
        } else {
            isHelperShownResultSubject.send(true)
        }
    }
    
    private func setHelperShown() {
        setHelperUseCase.execute()
    }
    
    private func fetchNotificationList() async {
        do {
            let notifications = try await fetchNotificationListUseCase.execute()
            self.notifications = notifications
            notificationResultSubject.send(.success(notifications))
        } catch {
            notificationResultSubject.send(.failure(error as? ByeBooError ?? ByeBooError.unknownError))
        }
    }
}
