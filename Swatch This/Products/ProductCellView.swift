//
//  ProductCellView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Russ Hooper on 8/22/24.
//

import SwiftUI

struct ProductCellView: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            /*
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
            image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 75, height: 75)
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
            */
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title ?? "n/a")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Price $" + String(product.price ?? 0))
                Text("Rating: " + String(product.rating ?? 0))
                Text("Category: " + (product.category ?? "n/a"))
                Text("Brand " + (product.brand ?? "n/a"))
            }
            .font(.callout)
            .foregroundColor(.secondary)

        }    }
}

#Preview {
    ProductCellView(product: Product(id: 1, title: "Test", description: "Description", price: 0, discountPercentage: 0, rating: 3, stock: 10, brand: "Acme", category: "aasdfads", thumbnail: "asdfads", images: []))
}
