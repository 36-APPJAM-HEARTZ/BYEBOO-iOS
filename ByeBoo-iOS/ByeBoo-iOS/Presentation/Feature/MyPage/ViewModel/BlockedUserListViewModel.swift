//
//  BlockedUserListViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/23/26.
//

import Combine
import Foundation

final class BlockedUserListViewModel {
    
    private var getBlockedUsersListSubject: PassthroughSubject<Result<[BlockedUserEntity], ByeBooError>, Never> = .init()
    private var deleteBlockUserSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private let getBlockedUsersListUseCase: GetBlockedUsersListUseCase
    private let deleteBlockedUserUseCase: DeleteBlockedUserUseCase
    private var blockedUsers: [BlockedUserEntity] = []
    
    var output: Output {
        Output(
            getBlockedUsersListPublisher: getBlockedUsersListSubject.eraseToAnyPublisher(),
            deleteBlockedUserPublisher: deleteBlockUserSubject.eraseToAnyPublisher()
        )
    }
    init(
        getBlockedUsersListUseCase: GetBlockedUsersListUseCase,
        deleteBlockedUserUseCase: DeleteBlockedUserUseCase
    ) {
        self.getBlockedUsersListUseCase = getBlockedUsersListUseCase
        self.deleteBlockedUserUseCase = deleteBlockedUserUseCase
    }
    
    var blockedUsersCount: Int {
        blockedUsers.count
    }
    
    func getBlockedUserName(at index: Int) -> String? {
        guard index >= 0 && index < blockedUsers.count else {
            return nil
        }
        return blockedUsers[index].name
    }
}

extension BlockedUserListViewModel: ViewModelType {
    enum Input {
        case viewDidLoad
        case deleteBlockedUser(index: Int)
    }
    
    struct Output {
        let getBlockedUsersListPublisher: AnyPublisher<Result<[BlockedUserEntity], ByeBooError>, Never>
        let deleteBlockedUserPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchBlocedUserList()
        case .deleteBlockedUser(let index):
            deleteBlockedUser(index: index)
        }
    }
}

extension BlockedUserListViewModel {
    private func fetchBlocedUserList() {
        Task {
            do {
                self.blockedUsers = try await getBlockedUsersListUseCase.execute()
                ByeBooLogger.debug("차단한 유저 \(blockedUsers)")
                getBlockedUsersListSubject.send(.success(blockedUsers))
            } catch(let error as ByeBooError) {
                ByeBooLogger.error(error)
                getBlockedUsersListSubject.send(.failure(error))
            }
        }
    }
    
    private func deleteBlockedUser(index: Int) {
        Task {
            do {
                let blockID = blockedUsers[index].blockID
                try await deleteBlockedUserUseCase.execute(blockID: blockID)
                ByeBooLogger.debug("차단 완료 \(blockID)")
                deleteBlockUserSubject.send(.success(()))
            } catch(let error as ByeBooError) {
                ByeBooLogger.error(error)
                deleteBlockUserSubject.send(.failure(error))
            }
            
        }
    }
}
