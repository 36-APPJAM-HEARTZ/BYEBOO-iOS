//
//  HomeTests.swift
//  ByeBooTests
//
//  Created by 최주리 on 8/25/25.
//

import Testing
@testable import ByeBoo_iOS

struct HomeTests {
    
    // 안보이는 게 true
    @Test("🏁 [currentStatus가 beforeJourneyStart]이고 [isHelperShown이 false]일 때 ✅ helperResult가 false인가")
    func case1() async throws {
        // Given
        let viewModel = makeViewModel(
            questStatus: .init(
                todayComplete: false,
                currentStatus: .beforeJourneyStart,
                questCount: 0
            ),
            isHelperShown: false
        )
        
        // When
        viewModel.action(.viewWillAppear)
        
        // Then
        let stream = viewModel.output.helperResult.values
        var iterator = stream.makeAsyncIterator()
        
        // 초기값 무시
        _ = await iterator.next()
        
        let value = await iterator.next()
        #expect(value == false)
    }
    
    @Test("🏁 currentStatus가 afterJourney, afterQuest, beforeQuest이고 isHelperShown이 false일 때 ✅ helperResult가 true인지")
    func case2() async throws {
        // Given
        let viewModel = makeViewModel(
            questStatus: .init(
                todayComplete: false,
                currentStatus: .afterJourney,
                questCount: 0
            ),
            isHelperShown: false
        )
        
        // When
        viewModel.action(.viewWillAppear)
        
        // Then
        let stream = viewModel.output.helperResult.values
        var iterator = stream.makeAsyncIterator()
        
        // 초기값 무시
        _ = await iterator.next()
        
        let value = await iterator.next()
        #expect(value == true)
    }
    
    @Test("🏁 isHelperShown이 true일 때 ✅ helperResult가 true인지")
    func case3() async throws {
        // Given
        let viewModel = makeViewModel(
            questStatus: .init(
                todayComplete: false,
                currentStatus: .beforeQuest,
                questCount: 0
            ),
            isHelperShown: true
        )
        
        // When
        viewModel.action(.viewWillAppear)
        
        // Then
        let stream = viewModel.output.helperResult.values
        var iterator = stream.makeAsyncIterator()
        
        // 초기값 무시
        _ = await iterator.next()
        
        let value = await iterator.next()
        #expect(value == true)
    }
    
    func makeViewModel(
        questStatus: UserQuestStatusEntity? = nil,
        isHelperShown: Bool? = nil
    ) -> HomeViewModel {
        let userRepository: UsersInterface = MockUserRepository(questStatus: questStatus, isHelperShown: isHelperShown)
        
        return HomeViewModel(
            fetchCharacterDialogueUseCase: DefaultFetchCharacterDialogueUseCase(repository: userRepository),
            fetchQuestStatusUseCase: DefaultFetchQuestStatusUseCase(repository: userRepository),
            fetchUserJourneyUseCase: DefaultFetchUserJourneyUseCase(repository: userRepository),
            getUserNameUseCase: DefaultGetUserNameUseCase(repository: userRepository),
            setHelperUseCase: DefaultSetHelperUseCase(repository: userRepository),
            getHelperUseCase: DefaultGetHelperUseCase(repository: userRepository)
        )
    }

}
