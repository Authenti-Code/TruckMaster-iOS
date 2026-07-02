//
//  SettingsView.swift
//  TruckMaster
//

internal import SwiftUI

@available(iOS 16.0, *)
struct SettingsView: View {

    @StateObject var viewModel: SettingsViewModel

    var body: some View {
        ZStack(alignment: .topLeading) {

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // MARK: - Header
                    HStack {
                        ReusableText(
                            title: "settings_heading",
                            fontSize: 18,
                            fontName: "Livvic-SemiBold",
                            fontColor: AppColors.textBlack1
                        )

                        Spacer()

                        Button {
                            viewModel.notificationTapped()
                        } label: {
                            Image(ImageConstants.icNotification)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 16)

                    // MARK: - Profile Card
                    if let user = viewModel.state.user {
                        CardContainer(
                            cornerRadius: 16,
                            backgroundColor: AppColors.grey3
                        ) {
                            HStack(spacing: 12) {
                                if let profileImage = user.profileImage, !profileImage.isEmpty {
                                    AsyncImage(url: URL(string: profileImage)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Circle()
                                            .fill(AppColors.grey2)
                                            .frame(width: 50, height: 50)
                                            .shimmer()
                                    }
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                } else {
                                    Image(ImageConstants.user)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                }

                                VStack(alignment: .leading, spacing: 4) {

                                    Text(user.name)
                                        .font(.custom("Livvic-SemiBold", size: 15))
                                        .foregroundColor(AppColors.textBlack1)

                                    Text(user.email)
                                        .font(.custom("Livvic-Regular", size: 13))
                                        .foregroundColor(AppColors.grey1)
                                }

                                Spacer()

                                Button {
                                    viewModel.editTapped()
                                } label: {
                                    HStack(spacing: 4) {

                                        Text("Edit")
                                            .font(.custom("Livvic-SemiBold", size: 13))
                                            .foregroundColor(AppColors.secondary)

                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppColors.secondary)
                                    }
                                }
                            }
                            .padding(16)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                    }

                    // MARK: - Settings Items
                    ElevatedCardContainer(
                        cornerRadius: 16,
                        backgroundColor: .white
                    ) {
                        VStack(spacing: 0) {
                            ForEach(Array(viewModel.state.settingsItems.enumerated()), id: \.element.id) { index, item in
                                SettingsRowItem(item: item) {
                                    viewModel.settingsItemTapped(item)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)

                    // MARK: - Logout
                    Button {
                        Task { await viewModel.logoutTapped() } 
                    } label: {
                        HStack(spacing: 8) {
                            ReusableText(
                                title: "logout_label",
                                fontSize: 15,
                                fontName: "Livvic-SemiBold",
                                fontColor: AppColors.secondary
                            )
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(AppColors.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }

                    Spacer(minLength: 100)
                }
            }
            .navigationBarHidden(true)
            .scrollIndicators(.hidden)
//            .snackbar(
//                isShowing: viewModel.binding(for: \.state.showSnackbar),
//                message: viewModel.state.snackbarMessage,
//                type: viewModel.state.snackbarType
//            )
            .overlay {
                if viewModel.state.isLoading {
                    ZStack {
                        Color.black.opacity(0.3)

                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                    }
                    .ignoresSafeArea(edges: .top)
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

// MARK: - Settings Row Item
@available(iOS 16.0, *)
private struct SettingsRowItem: View {

    let item: SettingsItemModel
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(item.icon)
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.textBlack1)
                    .frame(width: 24)

                ReusableText(
                    title: LocalizedStringKey(item.title),
                    fontSize: 15,
                    fontName: "Livvic-Medium",
                    fontColor: AppColors.textBlack1
                )

                Spacer()

                Image(ImageConstants.rightArrowS)
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.grey1)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}

//#Preview {
//    if #available(iOS 16.0, *) {
//        let repo     = SettingsRepositoryImpl(apiClient: <#any APIClientProtocol#>)
//        let useCase  = GetUserProfileUseCase(repository: repo)
//        SettingsView(viewModel: SettingsViewModel(
//            getUserProfileUseCase: useCase,
//            router: AppRouter()
//        ))
//    } else { }
//}
