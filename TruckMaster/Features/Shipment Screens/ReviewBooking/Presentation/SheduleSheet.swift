//
//  SheduleSheet.swift
//  TruckMaster
//
//  Created by AuthentiCode on 26/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct SheduleSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SheduleViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ReusableText(
                    title: "shedule_title",
                    fontSize: 16,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )
                Spacer()
            }

            VStack(alignment: .leading, spacing: 15) {

                SheduleToggleRow(
                    title: "instant_booking_title",
                    isSelected: viewModel.state.instantBooking
                ) {
                    viewModel.instantTapped()
                }
                

                SheduleToggleRow(
                    title: "shedule_booking_title",
                    isSelected: viewModel.state.sheduleBooking
                ) {
                    viewModel.sheduledTapped()
                }

                if viewModel.state.sheduleBooking {
                    HStack(spacing: 12) {
                        DateField(
                            placeholder: "Date",
                            iconSystemName: "calendar",
                            date: viewModel.binding(for: \.state.selectedDate),
                            displayedComponents: .date
                        )

                        DateField(
                            placeholder: "Time",
                            iconSystemName: "clock",
                            date: viewModel.binding(for: \.state.selectedTime),
                            displayedComponents: .hourAndMinute
                        )
                    }
                }
            }

            PrimaryButton(title: "continue_title") {
                viewModel.continueTapped()
            }
            .padding(.vertical, 10)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
       
    }
    
}

private struct DateField: View {
    let placeholder: String
    let iconSystemName: String
    @Binding var date: Date
    let displayedComponents: DatePickerComponents

    @State private var showPicker = false
    @State private var hasSelected = false

    var body: some View {
        Button {
            showPicker = true
        } label: {
            HStack {
                Text(hasSelected ? formattedValue : placeholder)
                    .font(.custom("Livvic-Regular", size: 14))
                    .foregroundColor(hasSelected ? AppColors.textBlack1 : .gray)

                Spacer()

                Image(systemName: iconSystemName)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 14)
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showPicker) {
            if #available(iOS 16.0, *) {
                NavigationView {
                    VStack {
                        if displayedComponents == .date {
                            DatePicker(
                                "",
                                selection: $date,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                            .padding()
                        } else {
                            DatePicker(
                                "",
                                selection: $date,
                                displayedComponents: .hourAndMinute
                            )
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                        }

                        Spacer()
                    }
                    .navigationTitle(displayedComponents == .date ? "Select Date" : "Select Time")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                hasSelected = true
                                showPicker = false
                            }
                        }
                    }
                }
                .presentationDetents([.height(displayedComponents == .date ? 480 : 320)])
            } else {
                // Fallback on earlier versions
            }
        }
    }

    private var formattedValue: String {
        let formatter = DateFormatter()
        formatter.dateFormat = displayedComponents == .date ? "MMM d, yyyy" : "h:mm a"
        return formatter.string(from: date)
    }
}

private struct SheduleToggleRow: View {
    let title: LocalizedStringKey
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                Text(title)
                    .font(.custom("Livvic-Medium", size: 15))
                    .foregroundColor(AppColors.textBlack1)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(isSelected ? AppColors.colorBlue : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? AppColors.primary : Color.gray.opacity(0.15),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
        }
    }
}
