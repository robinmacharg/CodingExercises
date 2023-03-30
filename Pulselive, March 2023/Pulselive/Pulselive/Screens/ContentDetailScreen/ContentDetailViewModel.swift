//
//  ContentDetailScreenViewModel.swift
//  Pulselive
//
//  Created by Robin Macharg on 28/03/2023.
//

import Foundation
import SwiftUI
import Resolver

/**
 * ViewModel for the ContentDetailView
 */
final class ContentDetailViewModel: ObservableObject {

    @Injected private var api: APIServiceProviding

    /**
     * The possible UI states
     */
    enum UIState {
        case initial
        case loading
        case loaded
        case error(message: String)
    }

    /// The UI state
    @Published var uiState: UIState = .initial

    /// The article details
    @Published var article: PLContentDetailItem?

    let dateFormatter: DateFormatter = .init()

    init() {
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "en_GB")
    }

    /**
     * Retrieve the article data
     */
    @MainActor
    func loadArticle(id: Int) async {
        uiState = .loading
        do {
            article = try await api.getContentDetails(articleID: id).item
            uiState = .loaded
        } catch let error {
            Log.error("Failed to retrieve article list: \(error.localizedDescription)")
            uiState = .error(message: error.localizedDescription)
        }
    }
}
