//
//  NetworkError.swift
//  TruckMaster
//

internal import Foundation

enum NetworkError: LocalizedError {
    case invalidResponse
    case invalidStatusCode(Int)
    case decodingFailed
    case noData
    case apiError(String) 

//    var errorDescription: String? {
//        switch self {
//        case .invalidResponse:
//            return "Invalid server response"
//        case .invalidStatusCode(let code):
//            return "Request failed with status code \(code)"
//        case .decodingFailed:
//            return "Failed to decode response"
//        case .noData:
//            return "No data found"
//        case .apiError(let message):
//            return message
//        }
//    }
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Something went wrong. Please try again."

        case .invalidStatusCode:
            return "We couldn't process your request. Please try again."

        case .decodingFailed:
            return "Unable to load data right now. Please try again."

        case .noData:
            return "No data available."

        case .apiError(let message):
            return message.isEmpty
                ? "Something went wrong. Please try again."
                : message
        }
    }
}
