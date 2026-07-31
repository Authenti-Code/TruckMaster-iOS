//
//  SocketServiceProtocol.swift
//  TruckMaster-Company
//
//  Created by AuthentiCode on 24/07/26.
//
internal import Foundation

protocol SocketServiceProtocol: AnyObject {
    func connect(resource: String, resourceId: String)
    func disconnect()
    func events(_ event: String) -> AsyncStream<Data>
}
