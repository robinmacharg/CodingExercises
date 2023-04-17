//
//  PriceChartScreen.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 12/04/2023.
//

import SwiftUI
import Charts

struct PriceChartScreen: View {

    @Environment(\.colorScheme) var colorScheme

    @StateObject var viewModel: PriceChartScreenViewModel

    @State var selectedDate: Date?
    @State var selectedPrice: Double?

    private var market: CGMarket?

    init(market: CGMarket) {
        self.market = market
        _viewModel = StateObject(wrappedValue: PriceChartScreenViewModel(marketID: market.id))
    }

    var body: some View {
        VStack {
            marketInfo
            switch viewModel.uiState {
            case .initial, .loading:
                VStack {
                    Spacer()
                    LoadingOverlay(message: "Loading Market Data")
                    Spacer()
                }

            case .loaded:
                ZStack {
                    chart
                    chartSelection
                }

            case .error:
                VStack {
                    Spacer()
                    errorOverlay
                    Spacer()
                }
            }

            Spacer()

            periodPicker
        }
        .padding(8)
        .task {
            await viewModel.loadPrices()
        }
    }

    /**
     * The market info header
     */
    private var marketInfo: some View {
        Group {
            if let market {
                VStack(alignment: .leading) {
                    HStack {
                        MarketImage(market: market)
                        Text(market.symbol.uppercased())
                            .foregroundColor(colorScheme == .light ? .black : .gray)
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                    }
                    Text("\(market.currentPrice.toAbbreviatedString())")
                    Text("\(DateFormatter.priceChartInfoFormatter.string(from: Date()))")
                }
            }
        }
        .frame(alignment: .leading)
    }

    /**
     * The main chart
     */
    private var chart: some View {
        Chart {
            ForEach(viewModel.prices) { data in
                LineMark(
                    x: .value("date", data.date),
                    y: .value("price", data.price)
                )
            }

            // Highlight the user selection if they've made one
            if let selectedDate, let selectedPrice {
                RuleMark(x: .value("date", selectedDate))
                    .foregroundStyle(Color.red)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))

                RuleMark(y: .value("price", selectedPrice))
                    .foregroundStyle(Color.red)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))

//                if let selectedPrice {
                    PointMark(
                        x: .value("date", selectedDate),
                        y: .value("price", selectedPrice))
                    .symbolSize(CGSize(width: 20, height: 20))
                    .foregroundStyle(Color.green.opacity(0.7))
//                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 4)) { axisValue in
                AxisGridLine()
                AxisValueLabel {
                    Text("\(viewModel.xAxisLabel(value: axisValue))")
                }
            }
        }
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 4)) { axisValue in
                AxisValueLabel {
                    Text("\(viewModel.yAxisLabel(value: axisValue))")
                }
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(DragGesture()
                        .onChanged { value in
                            updateChartSelection(at: value.location, proxy: proxy, geometry: geometry)
                        }
                    )
                    .onTapGesture { location in
                        updateChartSelection(at: location, proxy: proxy, geometry: geometry)
                    }
            }
        }
    }

    /**
     * Info on the selected value - date and price
     */
    private var chartSelection: some View {
        Group {
            if let selectedDate, let selectedPrice {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(DateFormatter.priceChartInfoFormatter.string(from: selectedDate))")
                            Text("\(selectedPrice.toAbbreviatedString())")
                        }
                        .padding()
                        .background(Color("lightGray").opacity(0.7))
                        .cornerRadius(10)
                        .padding(.top)

                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }

    /**
     * Updates the selected date and price when the user taps or drags over the chart
     */
    private func updateChartSelection(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x

        guard let date: Date = proxy.value(atX: xPosition) else {
            return
        }

        selectedDate = viewModel.prices.first(where: { price in
            price.date > date
        })?.date

        selectedPrice = viewModel.prices.first(where: { $0.date == selectedDate })?.price
    }

    /**
     * A segmented picker allowing the user to alter the period/range of the chart
     */
    private var periodPicker: some View {
        Picker("", selection: $viewModel.chartPeriod) {
            ForEach(viewModel.chartPeriods, id: \.self) {
                Text("\($0.rawValue)")
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: viewModel.chartPeriod) { _ in
            Task {
                selectedPrice = nil
                selectedDate = nil
                await viewModel.loadPrices()
            }
        }
        .disabled(viewModel.periodPickerIsEnabled)
    }

    /**
     * An error overlay allowing reloading
     */
    private var errorOverlay: some View {
        VStack(spacing: 8) {
            Text("There was an error loading market data.")
                .foregroundColor(.black)
            Button {
                Task {
                    await viewModel.loadPrices()
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
struct PriceChartScreen_Previews: PreviewProvider {
    static var previews: some View {
        PriceChartScreen(market: CGMarket.mockMarketBTC)
            .previewDisplayName("Bitcoin")
        PriceChartScreen(market: CGMarket.mockMarketETH)
            .previewDisplayName("Etherium")
    }
}
#endif
