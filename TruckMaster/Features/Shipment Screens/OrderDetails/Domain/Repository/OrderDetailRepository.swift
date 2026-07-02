//
//  OrderDetailRepository.swift
//  TruckMaster
//

protocol OrderDetailRepository {
    func fetchOrderDetail() async throws -> OrderDetailResponse
}
