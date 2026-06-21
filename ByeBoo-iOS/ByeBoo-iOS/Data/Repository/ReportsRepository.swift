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
    
    func reportCommonQuest(targetID: Int, targetType: CommonQuestTargetType) async throws {
        let reportRequestDTO: ReportRequestDTO = .init(targetType: targetType.rawValue, targetId: targetID)
        ByeBooLogger.debug("\(targetID), \(targetType)")
        _ = try await networkService.request(ReportsAPI.postReport(dto: reportRequestDTO))
    }
}
