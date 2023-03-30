//
//  ContentListViewModel.swift
//  Pulselive
//
//  Created by Robin Macharg on 28/03/2023.
//
// swiftlint:disable opening_brace

import Foundation
import Resolver

/**
 * ViewModel for the ContentListView
 */
public final class ContentListScreenViewModel: ObservableObject {

    @Injected private var api: APIServiceProviding

    /**
     * The possible UI states
     */
    enum UIState: Equatable {
        case initial
        case loading
        case loaded
        case error(message: String)
    }

    /// The list of articles
    @Published var articles: [PLContentListItem] = []

    /// The last time the articles were loaded
    var articlesLoaded: Date?

    /// The interval to wait before reloading articles
    let reloadInterval: Double = 10

    /// The UI state
    @Published var uiState: UIState = .initial

    let dateFormatter: DateFormatter = .init()

    init() {
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "en_GB")
    }

    /**
     * Retrieve the list of articles
     */
    @MainActor
    func loadArticles(force: Bool = false) async {
        // Only load the articles if we don't have them, or a minimum time has elapsed, or we're forcing a reload
        // i.e. pull-to-refresh
        if (articlesLoaded != nil && Date.now.timeIntervalSince(articlesLoaded ?? Date.now) > reloadInterval)
            || articlesLoaded == nil
            || force
        {
            uiState = .loading
            do {
                articles = try await api.getContentList().items.sorted(by: { $0.date < $1.date })
                uiState = .loaded
                articlesLoaded = Date.now
            } catch let error {
                Log.error("Failed to retrieve article list: \(error.localizedDescription)")
                uiState = .error(message: error.localizedDescription)
            }
        }
    }
}
