//
//  SocketService.swift
//  TruckMaster-Company
//
//  Created by AuthentiCode on 24/07/26.
//

internal import Foundation
import SocketIO

final class SocketService: SocketServiceProtocol {

    static let shared = SocketService()

    private var manager: SocketManager?
    private var socket: SocketIOClient?
    private let socketURL: URL
    private var isConnected = false
    private var pendingJoins: [(resource: String, resourceId: String)] = []

    private init(socketURL: URL = URL(string: ApiConstants.socketURL)!) {
        self.socketURL = socketURL
    }

    func connect(resource: String, resourceId: String) {
        guard isConnected, socket?.status == .connected else {
            pendingJoins.append((resource, resourceId))
            if manager == nil {
                setUpSocket()
            }
            return
        }
        joinRoom(resource: resource, resourceId: resourceId)
    }

    private func setUpSocket() {
        let manager = SocketManager(
            socketURL: socketURL,
            config: [
                .log(false),
                .compress,
                .reconnects(true),
                .reconnectAttempts(-1),
                .reconnectWait(2),
                .forceWebsockets(true)
            ]
        )
        self.manager = manager
        self.socket = manager.defaultSocket

        socket?.on(clientEvent: .connect) { [weak self] _, _ in
            guard let self = self else { return }
            self.isConnected = true
            for pending in self.pendingJoins {
                self.joinRoom(resource: pending.resource, resourceId: pending.resourceId)
            }
            self.pendingJoins.removeAll()
        }

        socket?.on(clientEvent: .disconnect) { [weak self] data, _ in
            Logger.log("Socket disconnected: \(data)", category: .info)
            self?.isConnected = false
        }

        socket?.on(clientEvent: .error) { [weak self] data, _ in
            Logger.log("Socket error: \(data)", category: .error)
            self?.isConnected = false
        }

        socket?.on(SocketEvent.joinRoom) { data, _ in
            if let payload = data.first {
                Logger.logSocketResponse(event: SocketEvent.joinRoom, payload: payload)
            }
        }

        socket?.onAny { event in
            Logger.logSocketEvent(name: event.event, items: event.items ?? [])
        }

        socket?.connect()
    }

    private func joinRoom(resource: String, resourceId: String) {
        let payload: [String: Any] = [
            "resource": resource,
            "resource_id": Int(resourceId) ?? resourceId
        ]


        socket?.emitWithAck(SocketEvent.joinRoom, payload)
            .timingOut(after: 10) { data in
                print(" join_room ack:", data)
                if let status = data.first as? String,
                   status == SocketAckStatus.noAck {
                    print(" join_room: no ack within 10s")
                    return
                }
                if let response = data.first {
                    print(" join_room response:", response)
                }
            }
    }

    func disconnect() {
        socket?.disconnect()
        manager = nil
        socket = nil
        isConnected = false
        pendingJoins.removeAll()
    }

    func events(_ event: String) -> AsyncStream<Data> {
        AsyncStream { continuation in
            socket?.on(event) { dataArray, _ in
                guard let payload = dataArray.first,
                      let data = try? JSONSerialization.data(withJSONObject: payload) else { return }
                continuation.yield(data)
            }

            continuation.onTermination = { [weak self] _ in
                self?.socket?.off(event)
            }
        }
    }
}
