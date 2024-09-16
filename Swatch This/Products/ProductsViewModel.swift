//
//  ProductsViewModel.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/5/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ProductsViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published var selectedSort: SortOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    private var lastDocument: DocumentSnapshot? = nil
    
    enum SortOption: String, CaseIterable {
        case noSort
        case priceHigh
        case priceLow
        
        var priceDescending: Bool? {
            switch self {
            case .noSort: return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }
    }
    
    func sortSelected(option: SortOption) async throws {
        
        self.selectedSort = option
        
        // reset everything when we change the filters
        self.products = []
        self.lastDocument = nil
        
        self.getProducts()
        
    }
    
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case smartphones
        case laptops
        case fragrances
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            }
            return self.rawValue
        }
    }
    
    func categorySelected(option: CategoryOption) async throws {
        self.selectedCategory = option
        
        // reset everything when we change the filters
        self.products = []
        self.lastDocument = nil
        
        self.getProducts()
        
    }
    
    func getProducts() {
        Task {
            let (newProducts, lastDocument) = try await ProductsManager.shared.getAllProducts(
                priceDescending: selectedSort?.priceDescending,
                forCategory: selectedCategory?.categoryKey,
                count: 10,
                lastDocument: lastDocument)
            
            self.products.append(contentsOf: newProducts)
            if let lastDocument {
                self.lastDocument = lastDocument
            }
        }
    }
    
    
    
    
    func getProductsCount() {
        Task {
            let count = try await ProductsManager.shared.getAllProductsCount()
            print("All product count: \(count)")
        }
    }
    
    func getProductsByRating() {
        Task {
            
            //  let newProducts = try await ProductsManager.shared.getProductsByRating(count: 3, lastRating: self.products.last?.rating) // will have issues if there are multiple products with the same rating
            
            let (newProducts, lastDocument) = try await ProductsManager.shared.getProductsByRating(
                count: 3,
                lastDocument: lastDocument) // safe to run if even when there are multiple products with the same rating
            
            self.products.append(contentsOf: newProducts)
            self.lastDocument = lastDocument
        }
    }
    
}

