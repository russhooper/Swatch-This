//
//  FavoritesView.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/2/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import SwiftUI

struct FavoritesView: View {
    
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        List {
            /*
            ForEach(viewModel.userFavoriteProducts, id: \.id.self) { item in
                ProductCellViewBuilder(productID: String(item.productID))
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Remove from favorites") {
                            viewModel.removeFromFavorites(favoriteProductID: item.id)
                        }
                    }))
            }
             */
        }
        .navigationTitle("Favorites")
        .onFirstAppear {
            viewModel.addListenerForFavorites()
        }
        
        
    }
}


#Preview {
    FavoritesView()
}
