//
//  OrderDetailRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//


final class OrderDetailRepositoryImpl: OrderDetailRepository {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchOrderDetail() async throws -> OrderDetailResponse {
        if #available(iOS 16.0, *) {
            try? await Task.sleep(for: .seconds(1))
        } else {
            // Fallback on earlier versions
        }

        return OrderDetailResponse(
            orderId: "ORD-2026-001",
            status: "pending",
            pickupAddress: OrderAddress(
                address: "2715 Ash Dr. San Jose, South Dakota 83475",
                latitude: "37.33233141",
                longitude: "-122.0312186",
                name: "John Doe",
                contact: "1234567890"
            ),
            dropAddress: OrderAddress(
                address: "1901 Thornridge Cir. Shiloh, Hawaii 81063",
                latitude: "37.77863061",
                longitude: "-122.4164345",
                name: "Jane Smith",
                contact: "9876543210"
            ),
            items: [
                OrderItem(
                    categoryId: "9",
                    categoryName: "Home & Furniture",
                    categoryImage: "https://picsum.photos/200",
                    subCategoryId: 29,
                    quantity: 5,
                    dimensions: [
                        OrderDimension(width: "2.2", length: "8.9")
                    ],
                    dimensionUnit: "m"
                ),
                OrderItem(
                    categoryId: "10",
                    categoryName: "Appliances",
                    categoryImage: "https://picsum.photos/200",
                    subCategoryId: 62,
                    quantity: 3,
                    dimensions: [
                        OrderDimension(width: "1.5", length: "2.0")
                    ],
                    dimensionUnit: "m"
                )
            ],
            extras: OrderExtras(
                helpers: 2,
                fragileHandling: false,
                stairsCarry: false,
                urgent: false,
                zipHandler: false,
                elevator: false,
                additionalInfo: nil
            ),
            scheduleType: "scheduled",
            scheduledAt: "2026-06-24T06:35:00Z",
            companyOffer: CompanyOffer(
                companyId: "1",
                companyName: "Company Name",
                companyImage: nil,
                rating: "4.0",
                truckType: "Pickup Truck",
                estimatedTime: "3 min",
                totalPrice: 150.0
            ),
            priceBreakdown: PriceBreakdown(
                distanceLabel: "8 km distance",
                distancePrice: 85.0,
                helpersPrice: 60.0,
                tax: 5.0,
                total: 150.0
            )
        )
    }
}
