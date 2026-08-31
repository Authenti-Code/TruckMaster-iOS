//
//  HelpSupportView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//


internal import SwiftUI

@available(iOS 16.0, *)
struct HelpSupportView: View {
    @ObservedObject var viewModel: HelpSupportViewModel

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button { viewModel.backTapped() } label: {
                        Image(ImageConstants.backImage)
                    }
                    Spacer()
                }
                ReusableText(
                    title: "help_support_title",
                    fontSize: 18,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            ReusableText(
                title: "help_support_subheading",
                fontSize: 14,
                fontName: "Livvic-Regular",
                fontColor: AppColors.grey1
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 12)

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.state.messages) { message in
                            ChatBubble(message: message)
                                .id(message.id)
                                .onAppear { viewModel.loadMoreIfNeeded(currentMessage: message) }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
                    .padding(.bottom, 12)
                }
                .scrollIndicators(.hidden)
                .onChange(of: viewModel.state.messages.count) { _ in
                    if let last = viewModel.state.messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            ChatInputBar(
                text: viewModel.binding(for: \.state.inputText),
                onSend: { viewModel.sendTapped() }
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
        .navigationBarHidden(true)
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
        .overlay {
            if viewModel.state.isLoading {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView().tint(.white).scaleEffect(1.5)
            }
        }
        .onAppear { viewModel.onAppear() }
    }
}

private struct ChatBubble: View {
    let message: ChatMessageModel

    @available(iOS 16.0, *)
    private var bubbleShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: 16,
            bottomLeadingRadius: message.isFromUser ? 16 : 4,
            bottomTrailingRadius: message.isFromUser ? 4 : 16,
            topTrailingRadius: 16
        )
    }

    var body: some View {
        HStack {
            if message.isFromUser { Spacer(minLength: 40) }

            if #available(iOS 16.0, *) {
                Text(message.text)
                    .font(.custom("Livvic-Regular", size: 14))
                    .foregroundColor(message.isFromUser ? .white : AppColors.textBlack1)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        bubbleShape.fill(message.isFromUser ? AppColors.primary : AppColors.grey2)
                    )
            } else {
                // Fallback on earlier versions
            }

            if !message.isFromUser { Spacer(minLength: 40) }
        }
    }
}

private struct ChatInputBar: View {
    @Binding var text: String
    let onSend: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            TextField("type_a_message", text: $text)
                .font(.custom("Livvic-Regular", size: 14))

            Button(action: onSend) {
                Image(ImageConstants.send)
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(AppColors.grey4)
        )
    }
}
