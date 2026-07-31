//
//  ApiClient.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

internal import Foundation
internal import UIKit

protocol APIClientProtocol {

    func request<Response: Decodable, Body: Encodable>(
        endpoint: EndPoints,
        method: HTTPMethod,
        body: Body?
    ) async throws -> Response

    func multipartRequest<Response: Decodable>(
        endpoint: EndPoints,
        method: HTTPMethod,
        parameters: [String: String],
        image: UIImage?,
        imageKey: String
    ) async throws -> Response
}

final class APIClient: APIClientProtocol {

    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    func request<Response: Decodable, Body: Encodable>(
        endpoint: EndPoints,
        method: HTTPMethod,
        body: Body? = nil
    ) async throws -> Response {

        let urlRequest = try buildRequest(endpoint: endpoint, method: method, body: body)

        Logger.logRequest(
            url:    endpoint.url.absoluteString,
            method: method.rawValue,
            body:   urlRequest.httpBody.flatMap { String(data: $0, encoding: .utf8) }
        )

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

        Logger.logResponse(
            statusCode: statusCode,
            body: String(data: data, encoding: .utf8)
        )

        try validateResponse(response: response, statusCode: statusCode)

        return try decode(data: data)
    }
    
    func multipartRequest<Response: Decodable>(
        endpoint: EndPoints,
        method: HTTPMethod,
        parameters: [String: String],
        image: UIImage?,
        imageKey: String
    ) async throws -> Response {

        let boundary = UUID().uuidString

        var request = URLRequest(url: endpoint.url)
        request.httpMethod = method.rawValue

        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )

        if let token = UserPreferences.shared.getToken() {
            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }

        var bodyData = Data()

        for (key, value) in parameters {
            bodyData.append("--\(boundary)\r\n")
            bodyData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            bodyData.append("\(value)\r\n")
        }

        if let image,
           let imageData = image.jpegData(compressionQuality: 0.8) {

            bodyData.append("--\(boundary)\r\n")
            bodyData.append(
                "Content-Disposition: form-data; name=\"\(imageKey)\"; filename=\"profile.jpg\"\r\n"
            )
            bodyData.append("Content-Type: image/jpeg\r\n\r\n")
            bodyData.append(imageData)
            bodyData.append("\r\n")

            print("📸 Image Size: \(imageData.count) bytes")
        }

        bodyData.append("--\(boundary)--\r\n")

        request.httpBody = bodyData

        // REQUEST LOG
        Logger.logRequest(
            url: endpoint.url.absoluteString,
            method: method.rawValue,
            body: """
            Parameters:
            \(parameters)
            """
        )

        let (responseData, response) = try await URLSession.shared.data(for: request)

        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

        // RESPONSE LOG
        Logger.logResponse(
            statusCode: statusCode,
            body: String(data: responseData, encoding: .utf8)
        )

        try validateResponse(
            response: response,
            statusCode: statusCode
        )

        return try decode(data: responseData)
    }
    
}

// MARK: - Private Helpers
private extension APIClient {

    func buildRequest<Body: Encodable>(
        endpoint: EndPoints,
        method: HTTPMethod,
        body: Body?
    ) throws -> URLRequest {

        var request        = URLRequest(url: endpoint.url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = UserPreferences.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            request.httpBody = try encoder.encode(body)
        }

        return request
    }

    func validateResponse(response: URLResponse, statusCode: Int) throws {
        guard response is HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200...299 ~= statusCode else {
            throw NetworkError.invalidStatusCode(statusCode)
        }
    }

    func decode<Response: Decodable>(data: Data) throws -> Response {
        do {
            return try decoder.decode(Response.self, from: data)
        } catch let decodingError {
            Logger.logError(decodingError)
            throw NetworkError.decodingFailed
        }
    }
}
