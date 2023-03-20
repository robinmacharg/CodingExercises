//
//  ProductListView.swift
//  Marketplace
//
//  Created by Robin Macharg on 20/03/2023.
//

import SwiftUI
import Combine

final class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []

    init(products: [Product] = []) {
        self.products = products
    }
}

struct ProductListView: View {

    @ObservedObject private var viewModel = ProductListViewModel()

    let width: CGFloat = 72.0
    let height: CGFloat = 108.0

    init(products: [Product] = []) {
        self.viewModel.products = products
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach($viewModel.products, id: \.id) { $item in
                    HStack {
                        Group {
                            if let url = item.images["750"]??.url {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(4)
                                    default:
                                        placeholderImage
                                    }
                                }
                            }
                            else {
                                placeholderImage
                            }
                        }
                        .frame(width: 72.0, height: 50)
                        .padding(.leading, 8)

                        Text("\(item.title)")
                        Spacer()
                    }
                }
            }
        }
    }

    private var placeholderImage: some View {
        Image(systemName: "takeoutbag.and.cup.and.straw")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
            .background {
                Color.gray.opacity(0.5)
                    .frame(width: 72.0, height: 50)
                    .cornerRadius(4)
            }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}
