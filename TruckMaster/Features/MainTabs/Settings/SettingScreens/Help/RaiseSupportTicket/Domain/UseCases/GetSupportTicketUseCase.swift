//
//  GetSavedAddressesUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

final class GetSupportTicketUseCase {
    private let repository: SupportTicketRepository

    init(repository: SupportTicketRepository) {
        self.repository = repository
    }

    func execute() async throws -> [SupportTicketModel] {
        try await repository.fetchTickets()
    }
    
}
