internal import SwiftUI

@available(iOS 16.0, *)
struct PreferredLanguageView: View {

    @StateObject private var viewModel: PreferredLanguageViewModel

    init(viewModel: PreferredLanguageViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(ImageConstants.gradient1)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: 250)
                .ignoresSafeArea(edges: .top)

            VStack(alignment: .leading) {
                HStack {
                    Button {
                        viewModel.backTapped()
                    } label: {
                        Image(ImageConstants.backImage)
                    }
                }
                .padding(.bottom, 40)

                ReusableText(title: "select_preferred_language_title", fontSize: 20, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
                    .padding(.bottom, 2)

                ReusableText(title: "select_preferred_language_subheading", fontSize: 15, fontName: "Livvic-Medium", fontColor: AppColors.grey1)
                    .padding(.bottom, 35)

                ReusableText(title: "select_language", fontSize: 15, fontName: "Livvic-Medium", fontColor: AppColors.textBlack1)

                DropdownField(
                    hint: "select_language",
                    options: viewModel.languages,
                    selected: $viewModel.selectedLanguage
                )

                Spacer()

                PrimaryButton(title: "continue_title", isEnabled: !viewModel.selectedLanguage.isEmpty) {
                    viewModel.continueTapped()
                }
            }
            .navigationBarHidden(true)
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}
