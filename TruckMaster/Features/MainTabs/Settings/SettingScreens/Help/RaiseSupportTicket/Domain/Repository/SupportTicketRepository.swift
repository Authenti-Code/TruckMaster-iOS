//
//  SavedAddressRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

protocol SupportTicketRepository {
    func fetchTickets() async throws -> [SupportTicketModel]
    func raiseTicket(request: RaiseTicketRequestModel) async throws -> RaiseTicketResponseModel
    
}
