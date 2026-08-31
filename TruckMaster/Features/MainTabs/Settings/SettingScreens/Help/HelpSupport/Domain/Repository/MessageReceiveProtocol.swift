//
//  MessageReceiveProtocol.swift
//  TruckMaster
//
//  Created by AuthentiCode on 31/08/26.
//

import Foundation

protocol MessageReceiveProtocol {
    func startListening(resource: String, resourceId: String)
    func stopListening()
    func onMessageReceived() -> AsyncStream<Messages>
}

final class MessageSocketRepository: MessageReceiveProtocol {
    private let socketService: SocketServiceProtocol

    init(socketService: SocketServiceProtocol = SocketService.shared) {
        self.socketService = socketService
    }

    func startListening(resource: String, resourceId: String) {
        socketService.connect(resource: resource, resourceId: resourceId)
    }

    func stopListening() {
        socketService.disconnect()
    }

 

    func onMessageReceived() -> AsyncStream<Messages> {
        let messageStream = socketService.events(SocketEvent.newTicketMessage)
        return AsyncStream { continuation in
            let messageTask = Task {
                for await data in messageStream {
                    print(" raw socket data received:", String(data: data, encoding: .utf8) ?? "non-utf8")
                    do {
                        let message = try JSONDecoder().decode(Messages.self, from: data)
                        continuation.yield(message)
                    } catch {
                        print("❌ decode error:", error)
                    }
                }
            }
            continuation.onTermination = { _ in
                messageTask.cancel()
            }
        }
    }
}

