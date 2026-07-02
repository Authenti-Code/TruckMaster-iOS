//
//  SavedAddressRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

final class SavedAddressRepositoryImpl: SavedAddressRepository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchAddresses() async throws -> [SavedAddressModel] {
        let response: BaseResponse<SavedAddressResponseModel> =
            try await apiClient.request(
                endpoint: .getAddress,
                method: .post,
                body: nil as EmptyModel?
            )

        guard response.success == "true" else {
            throw NetworkError.apiError(
                response.message.isEmpty
                    ? "Something went wrong. Please try again."
                    : response.message
            )
        }

        return response.data?.addresses ?? []
    }
    
    func deleteAddress(id: Int) async throws -> Bool {
           let response: BaseResponse<DeleteAddressResponseModel> =
               try await apiClient.request(
                   endpoint: .deleteAddress,
                   method: .post,
                   body: DeleteAddressRequestModel(id: id)
               )

           guard response.success == "true" else {
               throw NetworkError.apiError(
                   response.message.isEmpty
                       ? "Something went wrong. Please try again."
                       : response.message
               )
           }

           return true
       }
}
