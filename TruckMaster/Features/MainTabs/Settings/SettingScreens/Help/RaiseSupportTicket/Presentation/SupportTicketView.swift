//
//  SavedAddressView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct SupportTicketView: View {

    @ObservedObject var viewModel: SupportTicketViewModel

    var body: some View {
        ZStack(alignment: .bottom) {

            VStack(spacing: 0) {

                // Nav Bar
                HStack {
                    Button { viewModel.backTapped() } label: {
                        Image(ImageConstants.backImage)
                    }

                    Spacer()

                    ReusableText(
                        title: "raise_support_ticket_heading",
                        fontSize: 18,
                        fontName: "Livvic-SemiBold",
                        fontColor: AppColors.textBlack1
                    )

                    Spacer()

                    Color.clear.frame(width: 36, height: 36)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)

                // Content
                if viewModel.state.isLoading {
                    skeletonView
                } else if viewModel.state.ticket.isEmpty {
                    Spacer()
                    EmptyStateView(
                        image: ImageConstants.noTickets,
                        title: "no_ticket_found_heading",
                        message: "no_ticket_found_subheading"
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.state.ticket) { ticket in
                                SupportTicketCardView(
                                    ticket: ticket,
                                    ticketType: "Driver",
                                    assigneeName: "",
                                    assigneeAvatar: "",
                                    description: ""
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 100)
                    }
                    .scrollIndicators(.hidden)
                }
            }

            Button {
                viewModel.raiseTicketTapped()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))

                    ReusableText(
                        title: "raise_ticket_title",
                        fontSize: 15,
                        fontName: "Livvic-SemiBold",
                        fontColor: .white
                    )
                }
                .foregroundColor(.white)
                .frame(maxWidth: 200)
                .frame(height: 52)
                .background(AppColors.primary)
                .clipShape(Capsule())
                .padding(.horizontal, 40)
                .padding(.bottom, 16)
            }

        }
        .navigationBarHidden(true)
        .sheet(isPresented: viewModel.binding(for: \.state.showRaiseTicketSheet)) {
            if let raiseTicketViewModel = viewModel.makeRaiseTicketViewModel() {
                if #available(iOS 16.4, *) {
                    RaiseTicketSheet(viewModel: raiseTicketViewModel)
                        .presentationDetents([.height(350)])
                        .presentationBackground(.white)
                } else {
                    RaiseTicketSheet(viewModel: raiseTicketViewModel)
                }
            }
        }
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
        .dismissKeyboardOnTap()
        .onAppear { viewModel.onAppear() }
    }

    // MARK: - Skeleton
    private var skeletonView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(0..<3, id: \.self) { _ in
                    SavedAddressSkeletonCard()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }

}

// MARK: - Skeleton Card
@available(iOS 16.0, *)
struct SupportTicketCardView: View {

    let ticket: SupportTicketModel
    let ticketType: String
    let assigneeName: String
    let assigneeAvatar: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Header
            HStack {
                Text(ticket.status.capitalized)
                    .font(.custom("Livvic-SemiBold", size: 12))
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(statusColor.opacity(0.12))
                    )

                Spacer()

                Text(ticketType)
                    .font(.custom("Livvic-Regular", size: 14))
                    .foregroundColor(AppColors.grey1)
            }

            // Subject
            Text(ticket.subject)
                .font(.custom("Livvic-SemiBold", size: 16))
                .foregroundColor(AppColors.textBlack1)

            // Description
            Text(description)
                .font(.custom("Livvic-Regular", size: 14))
                .foregroundColor(AppColors.grey1)
                .multilineTextAlignment(.leading)

            // Footer
            HStack {
                HStack(spacing: 8) {
                    AsyncImage(url: URL(string: assigneeAvatar)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Circle()
                            .fill(AppColors.grey3)
                    }
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())

                    Text(assigneeName)
                        .font(.custom("Livvic-Medium", size: 14))
                        .foregroundColor(AppColors.textBlack1)
                }

                Spacer()

                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .foregroundColor(AppColors.grey1)
                    Text(formattedDate)
                        .font(.custom("Livvic-Regular", size: 13))
                        .foregroundColor(AppColors.grey1)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
    }

    private var statusColor: Color {
        switch ticket.status.lowercased() {
        case "open", "in progress": return .green
        case "closed": return .gray
        default: return AppColors.grey1
        }
    }

    private var formattedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: ticket.createdAt) else {
            return ticket.createdAt
        }

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd/MM/yyyy"
        return displayFormatter.string(from: date)
    }
}
