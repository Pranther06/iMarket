//
//  CartView.swift
//  iMarket
//
//  Created by Pranav Agrawala on 9/12/24.
//

import SwiftUI

struct CartView: View {
    @State private var delivery = false
    @Binding var cartProducts: [Product]
    @State private var showPrice = false
    
    //Calculate price before tax and savings
    var subtotalPrice: Double {
        cartProducts.reduce(0) { sum, product in
            return sum + product.price
        }
    }

    //Calculate total savings
    var totalDiscount: Double {
        cartProducts.reduce(0) { discountSum, product in
            let discountAmount = product.price * (product.discountPercentage / 100)
            return discountSum + discountAmount
        }
    }

    //Calculate tax from subtotal
    var taxPrice: Double {
        return 0.0913 * subtotalPrice //Sales tax in Cupertino is 9.13%
    }
    
    //Calculate total price from subtotal, discounts, and tax
    var totalPrice: Double {
        return subtotalPrice - totalDiscount + taxPrice
    }
    
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Cart")
                .font(.title)
                .padding(.leading)
                .padding(.top)
                .bold()
            HStack {
                //Display pick up/delivery options
                Menu {
                    Button(action: { delivery = false }) {
                        Label("Pick up", systemImage: delivery ? "" : "checkmark")
                    }
                    Button(action: { delivery = true }) {
                        Label("Delivery", systemImage: delivery ? "checkmark" : "")
                    }
                } label: {
                    HStack {
                        Text(delivery ? "Delivery" : "Pick up")
                            .foregroundColor(.primary)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.primary)
                    }
                    .bold()
                }
                if delivery {
                    Text("to")
                }
                else {
                    Text("from")
                }
                Text("Cupertino")
                    .bold()
                    .underline()
            }
            .padding(.leading)
            
            //Display products in cart
            ScrollView {
                ForEach(cartProducts) { product in
                    HStack{
                        
                        AsyncImage(url: URL(string: product.thumbnail)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)

                        Text(product.title)
                            .lineLimit(1)
                        
                        Spacer()
                        
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
                    }
                    .padding(.horizontal)
                }
                
                //Display total prices
                VStack(alignment: .leading) {
                    HStack {
                        Text("$\(totalPrice, specifier: "%.2f") total ")
                            .bold()
                        
                        Spacer()
                        
                        Button(action: {
                            showPrice.toggle()
                        }, label:{
                            Image(systemName: showPrice ? "chevron.up" : "chevron.down")
                                .foregroundColor(.primary)
                                .bold()
                        })
                    }
                    .padding(.bottom, 5)
                    Text("\(cartProducts.count) Items")
                        .foregroundColor(.gray)
                    
                    //Show entire price breakdown
                    if showPrice {
                        Divider()
                        HStack{
                            Text("Subtotal")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("$\(subtotalPrice, specifier: "%.2f")")
                        }
                        HStack{
                            Text("Savings")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("$\(totalDiscount, specifier: "%.2f")")
                        }
                        HStack{
                            Text("Taxes")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("$\(taxPrice, specifier: "%.2f")")
                        }
                    }
                    
                }
                .padding()
                .background(Color(.systemGray4))
                .cornerRadius(10)
                .padding()
            }
            
            
            Button {
                
            } label: {
                Text("Check out")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
            .buttonStyle(DarkenButtonStyle(color: .blue))
            .cornerRadius(20)
            .padding()
        }
    }
}

#Preview {
    CartView(cartProducts: .constant([]))
}

