//
//  MarketImage.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 13/04/2023.
//

import SwiftUI

/**
 * Load the market icon asynchronously, with progress and error placeholders
 */
struct MarketImage: View {

    var market: CGMarket

    /// The market image size.  Images are assumed to be square.
    private let iconSize: CGFloat = 40.0

    var body: some View {
        if let imageURL = URL(string: market.image) {
            AsyncImage(url: imageURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .cornerRadius(4)
                        .frame(width: iconSize, height: iconSize)
                }
                else if phase.error != nil {
                    marketImagePlaceholder
                }
                else {
                    ProgressView()
                        .frame(width: iconSize, height: iconSize)
                }
            }
        }
        else {
            marketImagePlaceholder
        }
    }

    /**
     * A placeholder when the market icon can't be downloaded
     */
    private var marketImagePlaceholder: some View {
        Color.clear.frame(width: iconSize, height: iconSize)
    }
}

#if DEBUG
struct MarketImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MarketImage(market: CGMarket.mockMarketETH)
                .border(Color.red)
            MarketImage(market: CGMarket.mockMarketBTC)
                .border(Color.red)

            // For size reference
            Rectangle()
                .frame(width: 40.0, height: 40.0)
                .foregroundColor(.gray)
                .border(Color.red)
        }
    }
}
#endif
