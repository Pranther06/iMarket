//
//  ProductCard.swift
//  iMarket
//
//  Created by Pranav Agrawala on 9/11/24.
//

import SwiftUI

//Custom button style for button press configuration
struct DarkenButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(color.brightness(configuration.isPressed ? -0.1 : 0))
    }
}

struct ProductCard: View {
    @Binding var product: Product
    @Binding var cartProducts: [Product]
    
    var body: some View {
        HStack {
            //Load product image
            AsyncImage(url: URL(string: product.thumbnail)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 150)
            
            //Display rest of product info
            VStack(alignment: .leading) {
                Text(product.title)
                    .lineLimit(1)
                //Show discounted price if there is a discount
                HStack {
                    if product.discountPercentage > 0 {
                        Text("$\(product.price, specifier: "%.2f")")
                            .strikethrough()
                            .foregroundColor(.gray)

                        let discountedPrice = product.price * (1 - product.discountPercentage / 100)
                        Text("$\(discountedPrice, specifier: "%.2f")")
                            .bold()
                            .foregroundColor(.red)
                    } else {
                        Text("$\(product.price, specifier: "%.2f")")
                            .bold()
                            .font(.title)
                    }
                }
                
                Text(capitalize(word: product.category))
                    .padding(5)
                    .background(Color(.systemGray4))
                    .cornerRadius(5)
                
                //Add to cart and favorite buttons
                HStack {
                    Button {
                        cartProducts.append(product)
                    } label: {
                        Text("Add to Cart")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 30)
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
            }
        }
    }
    
    //Capitalize function for product category
    func capitalize(word: String) -> String {
        let firstLetter = word.prefix(1).uppercased()
        let restOfString = word.dropFirst()
        return firstLetter + restOfString
    }
}

