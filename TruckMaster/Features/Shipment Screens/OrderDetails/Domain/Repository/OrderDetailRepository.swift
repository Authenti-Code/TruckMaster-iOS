//
//  OrderDetailRepository.swift
//  TruckMaster
//

protocol OrderDetailRepository {
    func fetchOrderDetail(request: OrderDetailRequest) async throws -> OrderOfferDetail
    func respondToOffer(request: OrderOfferRespondRequest) async throws -> OrderOfferRespondData
}
