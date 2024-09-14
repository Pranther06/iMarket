//
//  MainView.swift
//  iMarket
//
//  Created by Pranav Agrawala on 9/12/24.
//

import SwiftUI

struct MainView: View {
    @Binding var products: [Product]
    @State private var isEditing = false
    @State private var searchTerm = ""
    @Binding var cartProducts: [Product]
    @State private var selectedProduct: Product?
    
    var filteredProducts: [Product] {
        if searchTerm.isEmpty {
            return products
        } else {
            //Filter products based on title, category, brand, and tags
            return products.filter { product in
                product.title.lowercased().contains(searchTerm.lowercased()) ||
                product.category.lowercased().contains(searchTerm.lowercased()) ||
                (product.brand?.lowercased().contains(searchTerm.lowercased()) ?? false) ||
                product.tags.contains { $0.lowercased().contains(searchTerm.lowercased()) }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                //No items found
                if ((isEditing && searchTerm.isEmpty) || (isEditing && filteredProducts.isEmpty) || filteredProducts.isEmpty) {
                    ZStack {
                        Spacer().containerRelativeFrame([.horizontal, .vertical])
                        VStack{
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .bold()
                                .padding(.bottom)
                            Text("No Results")
                            Text("Check the spelling or try a new search.")
                        }
                    }
                }
                //Searching for items
                else if isEditing {
                    //Find the correct index in products array to provide a binding product
                    ForEach(filteredProducts.indices, id: \.self) { index in
                        
                        //Navigation button to product page
                        NavigationLink(destination: ProductView(product: $products[products.firstIndex(where: { $0.id == filteredProducts[index].id })!], cartProducts: $cartProducts)) {
                            HStack {
                                
                                //Display thumbnail and title
                                AsyncImage(url: URL(string: filteredProducts[index].thumbnail)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                
                                Text(filteredProducts[index].title)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            .padding(.leading)
                        }
                    }
                }
                //Regular product display
                else {
                    //Show number of results if searching
                    if !searchTerm.isEmpty {
                        HStack {
                            Text("\(filteredProducts.count) results for **\"\(searchTerm)\"**")
                            Spacer()
                        }
                        .padding()
                    }
                    ForEach(filteredProducts.indices, id: \.self) { index in
                        //Find the correct index in products array to provide a binding product
                        ProductCard(product: $products[products.firstIndex(where: { $0.id == filteredProducts[index].id })!], cartProducts: $cartProducts)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                    }
                }
            }
            .toolbar {
                //Search Bar
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 12))
                        TextField("What are you looking for?", text: $searchTerm, onEditingChanged: { isEditing in
                            self.isEditing = isEditing
                        })
                    }
                    .padding(5)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding(.bottom, 10)
                }
            }
            .navigationBarTitleDisplayMode(.inline) //Alignment
            
            //Show product page and provide a binding product
            .fullScreenCover(item: $selectedProduct) { product in
                ProductView(product: $products[products.firstIndex(where: { $0.id == product.id })!], cartProducts: $cartProducts)
            }
        }
    }
}


//API response structure
struct ProductResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

//Product structure
struct Product: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let tags: [String]
    let brand: String?
    let sku: String
    let weight: Double
    let dimensions: [String: Double]
    let warrantyInformation: String
    let shippingInformation: String
    let availabilityStatus: String
    let reviews: [Review]
    let returnPolicy: String
    let minimumOrderQuantity: Int
    let meta: [String: String]
    let thumbnail: String
    let images: [String]
    var favorite: Bool = false
    
    //Exclude favorite from being decoded
    private enum CodingKeys: String, CodingKey {
        case id, title, description, category, price, discountPercentage, rating, stock, tags, brand, sku, weight, dimensions, warrantyInformation, shippingInformation, availabilityStatus, reviews, returnPolicy, minimumOrderQuantity, meta, thumbnail, images
    }
}

//Reviews structure
struct Review: Codable, Hashable {
    let rating: Int
    let comment: String
    let date: String
    let reviewerName: String
}


#Preview {
    MainView(products: .constant([]), cartProducts: .constant([]))
}
