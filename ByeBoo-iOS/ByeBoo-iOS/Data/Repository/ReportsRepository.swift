//
//  ReportsRepository.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/5/26.
//

struct DefaultReportsRepository: ReportsInterface {

    private let networkService: NetworkService
    
    init(
        networkService: NetworkService
    ) {
        self.networkService = networkService
    }
    
    func reportCommonQuest(answerID: Int) async throws {
        let _ = try await networkService.request(
            ReportsAPI.postReport(answerID: answerID)
        )
    }
}
