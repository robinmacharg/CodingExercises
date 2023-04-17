//
//  PriceChartScreenViewModel.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 13/04/2023.
//

import Foundation
import Charts

/**
 * The view model for the market chart screen
 */
final class PriceChartScreenViewModel: ObservableObject {

    /**
     * Encapsulates a price at a point in time
     */
    struct Price: Identifiable {
        var id = UUID()

        var date: Date
        var price: Double
    }

    /**
     * The possible UI states
     */
    enum UIState: Equatable {
        case initial
        case loading
        case loaded
        case error(message: String)
    }

    /**
     * Enumerates the various periods over which we can query for chart data
     * String value used for picker display.
     */
    // swiftlint:disable identifier_name
    enum ChartPeriod: String, CaseIterable {
        case _6m = "6M"
        case _1y = "1Y"
        case _2y = "2Y"
        case _4y = "4Y"
        case all = "All"

        // Note: Naive multiples of 365 days
        func days() -> String {
            switch self {
            case ._6m: return "183"
            case ._1y: return "365"
            case ._2y: return "730"
            case ._4y: return "1460"
            case .all: return "max"
            }
        }
    }

    /// The UI state - used to display loading, error and chart
    @Published var uiState: UIState = .initial

    /// The list of date/prices used to plot the chart
    @Published var prices: [Price] = []

    /// The period the chart covers.  Defaults to 1 year
    @Published var chartPeriod: ChartPeriod = ._1y

    /// A list of all possible chart periods.  Used by the picker.
    var chartPeriods = ChartPeriod.allCases

    /// The ID of the currently shown market
    var marketID: String

    /// The backend API
    var apiService: APIServiceProviding

    /// The period picker is only enabled once the data has loaded
    var periodPickerIsEnabled: Bool {
        switch uiState {
        case .loaded:
            return false
        default:
            return true
        }
    }

    init(marketID: String, apiService: APIServiceProviding = APIService.shared) {
        self.marketID = marketID
        self.apiService = apiService
    }

    /**
     * Load and convert chart data from the backend
     */
    @MainActor
    func loadPrices() async {
        do {
            uiState = .loading
            let prices = try await apiService.getMarketChartData(marketID: marketID, period: chartPeriod.days()).prices
            self.prices = prices.map { price in
                // Note: Adjust for milliseconds
                Price(date: Date(timeIntervalSince1970: price[0] / 1000), price: price[1])
            }
            uiState = .loaded
        }
        catch let error {
            Log.warning("failed to load chartData: \(error.localizedDescription)")
            uiState = .error(message: "Failed to load chart data")
        }
    }

    /**
     * Convert the x-axis value into a suitable label
     */
    func xAxisLabel(value: AxisValue) -> String {
        if let timestamp = value.as(Date.self) {
            return xAxisLabel(timestamp: timestamp)
        }

        return ""
    }

    /**
     * Convenience formatter to allow testing.  AxisValue is not directly instantiable.
     */
    func xAxisLabel(timestamp: Date) -> String {
        switch chartPeriod {
        case ._6m, ._1y:
            return "\(DateFormatter.axisFormatter6M1Y.string(from: timestamp))"
        case ._2y:
            return "\(DateFormatter.axisFormatter2Y.string(from: timestamp))"
        case ._4y, .all:
            return "\(DateFormatter.axisFormatter4YAll.string(from: timestamp))"
        }
    }

    /**
     * Convert the y-axis value into a suitable label
     */
    func yAxisLabel(value: AxisValue) -> String {
        if let doubleValue = value.as(Double.self) {
            return String(format: "%.2f", doubleValue)
        }

        return ""
    }
}
