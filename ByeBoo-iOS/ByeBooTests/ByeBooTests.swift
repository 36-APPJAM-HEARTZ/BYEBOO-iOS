//
//  ByeBooTests.swift
//  ByeBooTests
//
//  Created by 최주리 on 8/25/25.
//

import Testing
@testable import ByeBoo_iOS

struct ByeBooTests {
    
    // (1) questStatus가 beforeJourneyStart이고, isHelperShown이 false일 때  -> false
    // (2) questStatus가 afterJourney, afterQuest, beforeQuest일 때 -> true
    // (3) isHelperShown이 true일 때 -> true
    // 안보이는 게 true
    @Test("questStatus에 따른 helper가 보여지는 여부")
    func helperShowingTest() async throws {
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
