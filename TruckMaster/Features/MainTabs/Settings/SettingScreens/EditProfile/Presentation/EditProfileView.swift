internal import SwiftUI

@available(iOS 16.0, *)
struct EditProfileView: View {

    @StateObject var viewModel: EditProfileViewModel
    @State private var showImageOptions = false
    @State private var showCamera = false
    @State private var showGallery = false

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header
            ZStack {

                ReusableText(
                    title: "edit_profile_title",
                    fontSize: 16,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )

                HStack {

                    Button {
                        viewModel.backTapped()
                    } label: {
                        Image(ImageConstants.backImage)
                    }

                    Spacer()

                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            // MARK: - Content
    

                VStack(spacing: 0) {

                    // MARK: - Profile Image
                    ZStack(alignment: .bottom) {
                        // Profile Image
                        if let selectedImage = viewModel.state.selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 110)
                                .clipShape(Circle())
                        } else if viewModel.state.profileImg.isEmpty {
                            Image(ImageConstants.user)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 110)
                                .clipShape(Circle())
                        } else {
                            AsyncImage(url: URL(string: viewModel.state.profileImg)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Circle()
                                    .fill(AppColors.grey2)
                                    .frame(width: 110, height: 110)
                                    .shimmer()
                            }
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                        }

                        // Bottom Overlay
                        Button {
                            showImageOptions = true
                        } label: {
                            ZStack {
                                Rectangle()
                                    .fill(.white.opacity(0.85))
                                    .frame(height: 28)

                                Image(ImageConstants.edit)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(AppColors.primary)
                            }
                        }
                    }
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
                    .padding(.top, 20)
                    .padding(.bottom, 30)

                    // MARK: - Form Fields
                    VStack(alignment: .leading, spacing: 20) {

                        ProfileInputField(
                            label: "name_text",
                            placeholder: "enter_name",
                            text: $viewModel.state.name,
                            keyboardType: .default
                        )

                        ProfileInputField(
                            label: "email_text",
                            placeholder: "enter_email",
                            text: $viewModel.state.email,
                            keyboardType: .emailAddress
                        )

                        ProfileInputField(
                            label: "contact_text",
                            placeholder: "enter_contact",
                            text: $viewModel.state.contact,
                            keyboardType: .phonePad
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()

                    PrimaryButton(title: "update_title") {
                        Task {
                             viewModel.updateTapped()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
    
        .background(Color.white)
        .navigationBarHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
        .overlay {
            if viewModel.state.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()

                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .confirmationDialog(
            "Select Image Source",
            isPresented: $showImageOptions,
            titleVisibility: .visible
        ) {

            Button("Choose From Gallery") {
                showGallery = true
            }

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Take Photo") {
                    showCamera = true
                }
            }

            Button("Cancel", role: .cancel) { }
        }

        .sheet(isPresented: $showGallery) {
            GalleryPicker { image in
                viewModel.state.selectedImage = image
                showGallery = false
            }
        }

        .fullScreenCover(isPresented: $showCamera) {
            CameraView { image in
                viewModel.state.selectedImage = image
                showCamera = false
            }
            .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraView { image in
                viewModel.state.selectedImage = image
                showCamera = false
            }
            .ignoresSafeArea()
        }
        .dismissKeyboardOnTap()
    }
}

// MARK: - Profile Input Field

private struct ProfileInputField: View {

    let label: LocalizedStringKey
    let placeholder: LocalizedStringKey
    @Binding var text: String
    let keyboardType: UIKeyboardType

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text(label)
                .font(.custom("Livvic-SemiBold", size: 14))
                .foregroundColor(AppColors.textBlack1)

            TextField(placeholder, text: $text)
                .font(.custom("Livvic-Regular", size: 14))
                .foregroundColor(AppColors.textBlack1)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            Color.black.opacity(0.08),
                            lineWidth: 1
                        )
                )
        }
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        let repo = EditProfileRepositoryImpl(apiClient: APIClient())
        let useCase = EditProfileUseCase(repository: repo)

        EditProfileView(
            viewModel: EditProfileViewModel(
                editProfileUseCase: useCase,
                router: AppRouter()
            )
        )
    }
}
