//
//  StoreManager.swift
//  Swatch This
//
//  Created by Russ Hooper on 2/17/21.
//  Copyright © 2021 Radio Silence. All rights reserved.
//

import Foundation
import StoreKit


open class StoreManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    typealias CompletionBlock = (Error?) -> Void

    
    @Published var myProducts = [SKProduct]()
    var request: SKProductsRequest!
    
    @Published var transactionState: SKPaymentTransactionState?

    
    private static let _singleton = StoreManager()
    public class var sharedInstance: StoreManager {
        return StoreManager._singleton
    }
    
    
    override init() {
        super.init()
    }
        
    
    func getProducts(productIDs: [String]) {
        print("Start requesting IAP products ...")
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Did receive IAP response")
        
        if !response.products.isEmpty {
            for fetchedProduct in response.products {
                DispatchQueue.main.async {
                    self.myProducts.append(fetchedProduct)
                }
                print("Product: \(fetchedProduct.localizedTitle)")
            }
        }
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("Invalid identifiers found: \(invalidIdentifier)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request did fail: \(error)")
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                transactionState = .purchasing
            case .purchased:
                print("Purchased")
                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                NotificationCenter.default.post(name: .paymentQueueUpdate, object: transactionState)
                transactionState = .purchased
            case .restored:
                print("Restored")
                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                NotificationCenter.default.post(name: .paymentQueueUpdate, object: transactionState)
                transactionState = .restored
            case .failed, .deferred:
                print("Payment Queue Error: \(String(describing: transaction.error))")
                queue.finishTransaction(transaction)
                NotificationCenter.default.post(name: .paymentQueueError, object: transactionState)
                transactionState = .failed
            default:
                queue.finishTransaction(transaction)
            }
        }
    }
    
    /*  // need for promoted IAP
    public func paymentQueue(_ queue: SKPaymentQueue,
         shouldAddStorePayment payment: SKPayment,
         for product: SKProduct) -> Bool {
        
        
        
        
    }
 */
    
    func purchaseProduct(product: SKProduct) {
        print("Purchase product")

        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("User can't make payment.")
        }
    }
    
    func restoreProducts() {
        print("Restoring products ...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("Restoring products finished")
        
        // if we hit this, make the Colors view update
        NotificationCenter.default.post(name: .paymentQueueError, object: transactionState)

    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("Restoring products failed")
        NotificationCenter.default.post(name: .paymentQueueError, object: transactionState)

    }
    
}

extension Notification.Name {
    static let paymentQueueUpdate = Notification.Name(rawValue: "paymentQueueUpdate")
    static let paymentQueueError = Notification.Name(rawValue: "paymentQueueError")

}

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
