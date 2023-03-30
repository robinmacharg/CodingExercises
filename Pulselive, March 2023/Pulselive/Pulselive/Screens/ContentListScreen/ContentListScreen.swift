//
//  ContentList.swift
//  Pulselive
//
//  Created by Robin Macharg on 28/03/2023.
//

import SwiftUI

/**
 * Displays a top-level list of article titles, subtitles and dates
 */
struct ContentListScreen: View {

    @StateObject var viewModel: ContentListScreenViewModel = .init()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Pull-to-refresh is included.  I'd typically use a ScrollView+LazyVList here but, given the size
                // of the data, and the overhead of (and mild obfuscation introduced by) manually implementing P2R for
                // them, I've gone with this approach - and this note - in the hope that this suffices.
                List(viewModel.articles, id: \.id) { item in
                    articleRow(item)
                }
                .listStyle(.plain)
                .refreshable {
                    Task {
                        await viewModel.loadArticles(force: true)
                    }
                }
                Spacer()
            }
            .foregroundColor(.black)

            if case .loading = viewModel.uiState {
                VStack(spacing: 8) {
                    ProgressView()
                    Text("Loading articles")
                }
                .padding()
                .background {
                    Color("lightGray")
                }
                .cornerRadius(10)
            }

            if case .error = viewModel.uiState {
                errorOverlay
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                header
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadArticles()
        }
    }

    /**
     * A single article row.  In a larger app would typically be split into a separate struct.  Included here for ease
     * of comprehension.
     */
    @ViewBuilder private func articleRow(_ article: PLContentListItem) -> some View {
        NavigationLink {
            ContentDetailScreen(id: article.id)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(article.title)
                        .font(.title)
                        .fontWeight(.bold)
                    Group {
                        Text(article.subtitle)
                            .italic()
                        Text(viewModel.dateFormatter.string(from: article.date))
                            .font(.caption)
                    }
                    .foregroundColor(.gray)
                }
                .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .accessibilityIdentifier("article\(article.id)")
    }

    private var errorOverlay: some View {
        VStack(spacing: 8) {
            Text("There was an error loading your articles.")
            Button {
                Task {
                    await viewModel.loadArticles(force: true)
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

    private var header: some View {
        VStack {
            HStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                Text("Articles")
                    .font(.largeTitle)
                Spacer()
            }
        }
    }
}

#if DEBUG
struct ContentList_Previews: PreviewProvider {
    static var previews: some View {
        ContentListScreen()
    }
}
#endif
