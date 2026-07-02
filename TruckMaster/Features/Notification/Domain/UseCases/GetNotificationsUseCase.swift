//
//  GetNotificationsUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

final class GetNotificationsUseCase {
    private let repository: NotificationRepository

    init(repository: NotificationRepository) {
        self.repository = repository
    }

    func execute() async throws -> [NotificationModel] {
        try await repository.fetchNotifications()
    }
}
