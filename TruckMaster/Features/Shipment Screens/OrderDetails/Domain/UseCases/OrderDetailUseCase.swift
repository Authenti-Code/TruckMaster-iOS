//
//  OrderDetailUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//

final class OrderDetailUseCase {
    private let repository: OrderDetailRepository
    
    init(repository: OrderDetailRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> OrderDetailResponse{
        try await repository.fetchOrderDetail()
    }
}
