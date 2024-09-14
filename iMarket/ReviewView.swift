//
//  ReviewView.swift
//  iMarket
//
//  Created by Pranav Agrawala on 9/12/24.
//

import SwiftUI

struct ReviewView: View {
    let review: Review
    let dateFormatter = DateFormatter()
    
    //Format date to Month Day, Year
    var formattedDate: String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = dateFormatter.date(from: review.date) {
            dateFormatter.dateStyle = .long
            return dateFormatter.string(from: date)
        } else {
            return "ERROR"
        }
    }
    
    var body: some View {
        //Display review
        VStack(alignment: .leading) {
            HStack {
                Text(review.reviewerName)
                    .bold()
                Spacer()
                Text(formattedDate)
                    .foregroundColor(.gray)
            }
            HStack {
                ForEach(0..<5) { index in
                    RatingStar(rating: Decimal(review.rating), color: .yellow, index: index)
                }
            }
            Text(review.comment)
            
            Divider()
        }
    }
}

