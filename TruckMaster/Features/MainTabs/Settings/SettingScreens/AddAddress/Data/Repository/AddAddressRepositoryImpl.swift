//
//  AddAddressRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 16/06/26.
//

final class AddAddressRepositoryImpl: AddAddressRepository {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func addAddress(request: AddAddressRequest) async throws -> AddressData {
        let response: BaseResponse<AddressData> =
            try await apiClient.request(
                endpoint: .addAddress,
                method: .post,
                body: request
            )
        
        guard response.success == "true" else {
              throw NetworkError.apiError(
                  response.message.isEmpty
                      ? "Something went wrong. Please try again."
                      : response.message
              )
          }

        guard let data = response.data else {
            throw NetworkError.noData
        }
        
        return data
    }
    
    func updateAddress(request: UpdateAddressRequest) async throws -> UpdateAddressResponseModel {
        let response: BaseResponse<UpdateAddressResponseModel> =
            try await apiClient.request(
                endpoint: .updateAddress,
                method: .post,
                body: request
            )

        guard response.success == "true" else {
            throw NetworkError.apiError(
                response.message.isEmpty
                    ? "Something went wrong. Please try again."
                    : response.message
            )
        }

        guard let data = response.data else {
            throw NetworkError.apiError("Something went wrong. Please try again.")
        }

        return data
    }
}
