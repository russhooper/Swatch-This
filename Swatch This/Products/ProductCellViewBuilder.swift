//
//  ProductCellViewBuilder.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Russ Hooper on 9/1/24.
//

import SwiftUI

struct ProductCellViewBuilder: View {
    
    let productID: String
    @State private var product: Product? = nil
    
    var body: some View {
        ZStack {
            if let product {
                ProductCellView(product: product)

            }
        }
        .task {
            self.product = try? await ProductsManager.shared.getProduct(productID: productID)
        }

    }
}

#Preview {
    ProductCellViewBuilder(productID: "1")
}
