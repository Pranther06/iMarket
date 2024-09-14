//
//  ContentView.swift
//  iMarket
//
//  Created by Pranav Agrawala on 9/11/24.
//

import SwiftUI


struct ContentView: View {
    @State private var products: [Product] = []
    @State private var cartProducts: [Product] = []
    
    var body: some View {
        TabView {
            //Main product view
            MainView(products: $products, cartProducts: $cartProducts)
                .tabItem {
                    Image(systemName: "carrot.fill")
                    Text("Products")
                }
            
            //Favorite items view
            FavoritesView(products: $products, cartProducts: $cartProducts)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("My Items")
                }
            
            //Cart products view
            CartView(cartProducts: $cartProducts)
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Cart")
                }
                .badge(cartProducts.count > 0 ? "\(cartProducts.count)" : nil)

        }
        .task {
            do {
                //Fetch items from API
                products = try await fetchProducts()
            } catch {
                print("ERROR: \(error)")
            }
        }
    }
    
    
    //Use API call to get all products
    func fetchProducts() async throws -> [Product] {
        let url = URL(string: "https://dummyjson.com/products")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        //Print any errors
        do {
            let decodedResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
            return decodedResponse.products
        } catch {
            print(error)
            throw error
        }
    }
}

#Preview {
    ContentView()
}
