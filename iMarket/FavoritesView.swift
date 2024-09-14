//
//  FavoritesView.swift
//  iMarket
//
//  Created by Pranav Agrawala on 9/12/24.
//

import SwiftUI

struct FavoritesView: View {
    @Binding var products: [Product]
    @Binding var cartProducts: [Product]
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("My Items")
                .font(.title)
                .padding(.leading)
                .padding(.top)
                .bold()
            
            //Display favorite products if there is any
            if products.filter({ $0.favorite }).isEmpty {
                Spacer()
                Text("No favorite items yet.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            } else {
                ScrollView {
                    //Display favorite products by passing binding product
                    ForEach(products.indices.filter { products[$0].favorite == true }, id: \.self) { index in
                        ProductCard(product: $products[index], cartProducts: $cartProducts)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                    }
                }
            }
        }
    }
}
