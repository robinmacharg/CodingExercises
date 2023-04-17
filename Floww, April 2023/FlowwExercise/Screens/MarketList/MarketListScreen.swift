//
//  MarketList.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 12/04/2023.
//

import SwiftUI

struct MarketListScreen: View {

    @Environment(\.colorScheme) var colorScheme

    @StateObject var viewModel = MarketListScreenViewModel()

    var body: some View {

        ZStack {
            if viewModel.markets.count > 0 {
                marketList
            }

            if case .loading = viewModel.uiState {
                LoadingOverlay(message: "Loading Markets")
            }
            else if case .error = viewModel.uiState {
                errorOverlay
            }
        }

        .toolbar {
            ToolbarItem(placement: .principal) {
                header
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Markets")
        .task {
            if case .initial = viewModel.uiState {
                await viewModel.loadMarkets()
            }
        }
    }

    /**
     * The list of markets, with pull-to-filter and pull-to-refresh
     */
    private var marketList: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack {
                    ForEach(
                        Array(zip(viewModel.filteredMarkets.indices, viewModel.filteredMarkets)),
                        id: \.0)
                    { (index, market) in
                        marketRow(index: index + 1, market: market)
                    }
                }
            }
            .refreshable {
                Task {
                    await viewModel.loadMarkets()
                }
            }
        }
        .foregroundColor(.black)
        .searchable(
            text: $viewModel.filterText,
            prompt: "Filter markets...")
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.characters)
        .onChange(of: viewModel.filterText) { _ in
            viewModel.filterMarkets()
        }
    }

    /**
     * A single market row.  In a larger app would typically be split into a separate struct.  Included here for ease
     * of comprehension.
     */
    @ViewBuilder private func marketRow(index: Int, market: CGMarket) -> some View {
        NavigationLink {
            PriceChartScreen(market: market)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("#\(index)")
                            .foregroundColor(.gray)
                        MarketImage(market: market)
                        VStack(alignment: .leading) {
                            Text(market.symbol.uppercased())
                                .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                            Text(Double(market.marketCap).toAbbreviatedString())
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        VStack(alignment: .trailing) {
                            Text("$\(String(format: "%.2f", market.currentPrice))")
                                .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                            if let priceChangePC = market.priceChangePercentage24H {
                                Text("\(String(format: "%.1f", priceChangePC))%")
                                    .foregroundColor(priceChangePC < 0 ? .red : .green)
                            }
                        }
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(colorScheme == .light ? Color("lightGray") : Color.gray)
                }
                .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .accessibilityIdentifier("market\(market.id)")
    }

    private var errorOverlay: some View {
        VStack(spacing: 8) {
            Text("There was an error loading market data.")
                .foregroundColor(.black)
            Button {
                Task {
                    await viewModel.loadMarkets()
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
                Text("Markets")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
        }
    }
}

#if DEBUG
struct MarketListScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MarketListScreen()
        }
    }
}
#endif
