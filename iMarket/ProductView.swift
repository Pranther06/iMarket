//
//  ProductView.swift
//  iMarket
//
//  Created by Pranav Agrawala on 9/12/24.
//

import SwiftUI

struct ProductView: View {
    @Binding var product: Product
    @Binding var cartProducts: [Product]
    @State private var selectedSortOption: String = "Highest to Lowest"
    
    //Sorted review options
    var sortedReviews: [Review] {
        switch selectedSortOption {
        case "Highest to Lowest":
            return product.reviews.sorted { $0.rating > $1.rating }
        case "Lowest to Highest":
            return product.reviews.sorted { $0.rating < $1.rating }
        case "Newest to Oldest":
            return product.reviews.sorted { $0.date > $1.date }
        case "Oldest to Newest":
            return product.reviews.sorted { $0.date < $1.date }
        default:
            return product.reviews
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                //Review stars
                HStack {
                    ForEach(0..<5) { index in
                        RatingStar(rating: Decimal(product.rating), color: .yellow, index: index)
                    }
                    Text("\(product.rating, specifier: "%.2f")")
                        .foregroundColor(.yellow)
                    Text("(\(product.reviews.count))")
                        .foregroundColor(.gray)
                }
                .padding(.top)
                
                //Display all images of product
                TabView {
                    ForEach(product.images, id: \.self) { url in
                            AsyncImage(url: URL(string: url)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 300)
                
                //Show discounted price if there is one
                HStack {
                    if let discount = product.discountPercentage, discount > 0 {
                        Text("$\(product.price, specifier: "%.2f")")
                            .strikethrough()
                            .foregroundColor(.gray)

                        let discountedPrice = product.price * (1 - discount / 100)
                        Text("$\(discountedPrice, specifier: "%.2f")")
                            .bold()
                            .foregroundColor(.red)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    } else {
                        Text("$\(product.price, specifier: "%.2f")")
                            .bold()
                            .font(.title)
                    }
                }
                
                //Show stock level of product
                HStack {
                    if product.stock == 0 {
                        Text("Out of Stock")
                            .foregroundColor(.red)
                            .bold()
                    }
                    else{
                        Text("In Stock (\(product.stock))")
                            .foregroundColor(product.stock < 10 ? .yellow : .green)
                            .bold()
                    }
                    Text("at")
                    Text("Cupertino")
                        .bold()
                        .underline()
                }
                .padding(.bottom)

                //Add to cart and favorite buttons
                HStack {
                    Button {
                        cartProducts.append(product)
                    } label: {
                        Text("Add to Cart")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 110)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(DarkenButtonStyle(color: .blue))
                    .cornerRadius(20)

                    Button {
                        product.favorite.toggle()
                    } label: {
                        Image(systemName: product.favorite ? "heart.fill" : "heart")
                            .foregroundColor(.primary)
                            .padding(10)
                    }
                    .buttonStyle(DarkenButtonStyle(color: Color(.systemGray4)))
                    .clipShape(Circle())
                }
                .padding(.bottom)

                //Product description
                Text("Description")
                    .font(.title)
                    .padding(.bottom, 5)

                Text(product.description)
                    .font(.body)
                    .padding(.bottom, 20)
                    .foregroundColor(.gray)

                //Reviews section
                HStack {
                    Text("Reviews")
                        .font(.title)
                    Spacer()
                    Menu {
                        Button(action: { selectedSortOption = "Highest to Lowest" }) {
                            Label("Highest to Lowest", systemImage: selectedSortOption == "Highest to Lowest" ? "checkmark" : "")
                        }
                        Button(action: { selectedSortOption = "Lowest to Highest" }) {
                            Label("Lowest to Highest", systemImage: selectedSortOption == "Lowest to Highest" ? "checkmark" : "")
                        }
                        Button(action: { selectedSortOption = "Newest to Oldest" }) {
                            Label("Newest to Oldest", systemImage: selectedSortOption == "Newest to Oldest" ? "checkmark" : "")
                        }
                        Button(action: { selectedSortOption = "Oldest to Newest" }) {
                            Label("Oldest to Newest", systemImage: selectedSortOption == "Oldest to Newest" ? "checkmark" : "")
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.up.arrow.down")
                            Text("Sort")
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(.systemGray4))
                        .foregroundColor(.primary) 
                        .cornerRadius(10)
                    }

                }

                //Display sorted reviews
                ForEach(sortedReviews, id: \.self) { review in
                    ReviewView(review: review)
                }
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
        .navigationTitle(product.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//Review star structure
struct RatingStar: View {
    var rating: Double
    var color: Color
    var index: Int

    var maskRatio: CGFloat {
        let mask = rating - CGFloat(index)
        
        switch mask {
        case 1...: return 1
        case ..<0: return 0
        default: return mask
        }
    }

    init(rating: Decimal, color: Color, index: Int) {
        self.rating = CGFloat(Double(rating.description) ?? 0)
        self.color = color
        self.index = index
    }

    var body: some View {
        ZStack {
            //Star outline
            Image(systemName: "star")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(self.color)

            //Fill star based on rating
            Image(systemName: "star.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(self.color)
                .mask(
                    Rectangle()
                        .size(width: 20 * self.maskRatio, height: 20)
                )
        }
        .frame(width: 20, height: 20)
    }
}
