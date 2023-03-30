//
//  ContentDetailScreen.swift
//  Pulselive
//
//  Created by Robin Macharg on 28/03/2023.
//

import SwiftUI

/**
 * Displays a detailed view of an article
 */
struct ContentDetailScreen: View {

    @StateObject private var viewModel: ContentDetailViewModel = .init()

    /// The article ID
    var id: Int

    var body: some View {
        Group {
            switch viewModel.uiState {
            case .initial, .loading:
                loadingOverlay

            case .loaded:
                if let article = viewModel.article {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text(article.subtitle)
                                .accessibilityIdentifier("subtitle\(article.id)")
                                .bold()
                            Text(viewModel.dateFormatter.string(from: article.date))
                                .padding(.bottom, 16)
                            Text(article.body)
                                .accessibilityIdentifier("body\(article.id)")
                            Spacer()
                        }
                    }
                    .navigationTitle(article.title)
                } else {
                    errorOverlay
                }
            case .error:
                errorOverlay
            }
        }
        .padding(.horizontal, 16)
        .task {
            await viewModel.loadArticle(id: id)
        }
    }

    private var loadingOverlay: some View {
        VStack(spacing: 8) {
            ProgressView()
            Text("Loading article")
        }
        .padding()
        .background {
            Color("lightGray")
        }
        .cornerRadius(10)
    }

    private var errorOverlay: some View {
        VStack(spacing: 8) {
            Text("There was a problem loading your article.")
            Button {
                Task {
                    await viewModel.loadArticle(id: id)
                }
            } label: {
                Text("Try again")
            }
        }
        .padding()
        .background {
            Color("lightGray")
        }
        .cornerRadius(10)
    }
}

#if DEBUG
struct ContentDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailScreen(id: 29)
    }
}
#endif
