//
//  Resolver.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

internal import Foundation

final class ApiClient {

    func request<T: Decodable>(
        endpoint: EndPoints,
        responseType: T.Type
    ) async throws -> T {

        let (data, _) = try await URLSession.shared
            .data(from: endpoint.url)

        return try JSONDecoder()
            .decode(T.self, from: data)
    }
}
