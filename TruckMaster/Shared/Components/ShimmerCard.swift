//
//  ShimmerCard.swift
//  TruckMaster
//
//  Created by AuthentiCode on 22/06/26.
//

internal import SwiftUI

struct SavedAddressSkeletonCard: View {
    var body: some View {
        CardContainer(cornerRadius: 12, backgroundColor: .white) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(AppColors.grey3)
                        .frame(width: 40, height: 40)
                        .shimmer()

                    VStack(alignment: .leading, spacing: 6) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.grey3)
                            .frame(width: 80, height: 13)
                            .shimmer()

                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.grey3)
                            .frame(width: 140, height: 11)
                            .shimmer()
                    }
                    Spacer()
                }

                RoundedRectangle(cornerRadius: 4)
                    .fill(AppColors.grey3)
                    .frame(maxWidth: .infinity)
                    .frame(height: 11)
                    .shimmer()
            }
            .padding(16)
        }
    }
}
