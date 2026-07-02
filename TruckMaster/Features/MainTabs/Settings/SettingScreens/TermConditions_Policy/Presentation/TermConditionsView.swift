//
//  TermsConditionsView.swift
//  TruckMaster
//

internal import SwiftUI
import WebKit

@available(iOS 16.0, *)
struct TermConditionsView: View {

    @StateObject var viewModel: TermsConditionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

        
            ZStack {
                HStack {
                    Button {
                        viewModel.backTapped()
                    } label: {
                        Image(ImageConstants.backImage)
                    }
                    Spacer()
                }

                ReusableText(
                    title: viewModel.isPolicy ? "privacy_policy_title" : "terms_conditions_title",
                    fontSize: 16,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)


            if viewModel.state.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            } else if viewModel.state.content.isEmpty {
                EmptyStateView(
                    title: "no_content_title",
                    message: "term_condition_not_available"
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            } else {
                HTMLContentView(htmlContent: viewModel.state.content)
                    .padding(.horizontal, 4)
            }
        }
        .navigationBarHidden(true)
        .scrollIndicators(.hidden)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct HTMLContentView: UIViewRepresentable {

    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.showsVerticalScrollIndicator = false
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            body {
                font-family: 'Helvetica Neue', sans-serif;
                font-size: 15px;
                color: #1A1A1A;
                line-height: 1.7;
                padding: 16px;
                margin: 0;
                background-color: transparent;
            }
            h1, h2, h3 {
                font-weight: 600;
                color: #1A1A1A;
            }
            p {
                margin-bottom: 12px;
            }
        </style>
        </head>
        <body>
            \(htmlContent)
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
}
