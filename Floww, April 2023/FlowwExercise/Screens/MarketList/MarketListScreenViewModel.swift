//
//  MarketListScreenViewModel.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 12/04/2023.
//

import SwiftUI

final class MarketListScreenViewModel: ObservableObject {

    enum UIState: Equatable {
        case initial
        case loading
        case loaded
        case error(message: String)
    }

    @Published var uiState: UIState = .initial

    @Published var markets: CGMarkets = []

    @Published var filteredMarkets: CGMarkets = []

    @Published var filterText: String = ""

    var apiService: APIServiceProviding

    init(apiService: APIServiceProviding = APIService.shared) {
        self.apiService = apiService
    }

    /**
     * Load market data, updating the UI
     */
    @MainActor
    func loadMarkets() async {
        do {
            uiState = .loading
            // Note the hardcoding of parameters
            markets = try await apiService.getMarkets(
                vsCurrency: "usd",
                order: "market_cap_desc",
                perPage: 250)
            filteredMarkets = markets
            uiState = .loaded
        }
        catch let error {
            Log.error("Failed to retrieve markets: \(error.localizedDescription)")
            uiState = .error(message: error.localizedDescription)
        }
    }

    /**
     * Filter markets.  Inclusive filter using a simple `contains()`.
     * Empty `filterText` implies no filtering.
     */
    func filterMarkets() {
        if filterText.count == 0 {
            filteredMarkets = markets
        }
        else {
            filteredMarkets = markets.filter({ market in
                market.symbol.lowercased().contains(filterText.lowercased())
            })
        }
    }
}
