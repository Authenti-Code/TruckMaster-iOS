//
//  BaseResponse.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

internal import Foundation

struct BaseResponse<T: Codable>: Codable {
    let success: String
    let message: String
    let data: T?
}

struct EmptyModel: Codable { }

typealias EmptyResponse = BaseResponse<EmptyModel>
