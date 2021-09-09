//
//  PurchaseVC.swift
//  mud engineer 2
//
//  Created by Pandos on 07.09.2021.
//

import StoreKit
import UIKit

class PurchaseVC: UIViewController, UITableViewDelegate, UITableViewDataSource,SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    private var models = [SKProduct] ()
    private let mass = ["Возврат средств"]
    
    @Published var transactionState: SKPaymentTransactionState?
    @Published var showActivityIndicator = false
    
//    private var productRequest: SKProductsRequest?
//
//    private let productIdentifiers = Set<String>(
//    arrayLiteral: "MudFluidDonata1")
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Наблюдатель за транзакцией
        SKPaymentQueue.default().add(self)
        startObserving(&UserInterfaceStyleManager.shared)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        fetchProducts()
        
    }
    
    // Table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return models.count}
        else {return mass.count}
//        return models.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let product = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(product.localizedTitle): \(product.localizedDescription) - \(product.priceLocale.currencySymbol ?? "₽")\((product.price))"
        return cell
        }
        else {
//            let returnPurches = mass[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Возврат средств"
            return cell
            
            
        }
    }
    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 52.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            // Show purchase
        if indexPath.section == 0 {
        let payment = SKPayment(product: models[indexPath.row])
        //запрос оплаты
        SKPaymentQueue.default().add(payment)
        }
        else {
//            Возврат средств:
            SKPaymentQueue.default().restoreCompletedTransactions()
            let alert = UIAlertController(title: "Thank You", message: "Your purchase(s) were restored.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)

        }
    }
    
    // Products
    
    enum Product: String, CaseIterable {
        case donat1 = "MudFluidDonata0"
        case donat = "MudFluidDonata1"
        case donat200 = "MudFluidDonata2"
      
    }
    
    // Функция получения продуктов из app store по заданным идентификаторам
    
    private func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue})))
//        productRequest?.cancel()
//        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
        
//        self.productRequest = request
        
    }
        
    //ПОлучение ответа от app store - подробная информация о продукте
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            print("Count: \(response.products.count)")
            // Помещаем в наш массив models полученные продукты с app store
            self.models = response.products
            // обновляем нашу таблицу для отображения доступных продуктов
            self.tableView.reloadData()
    }

  }
    
    

}

extension PurchaseVC {
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        guard  !response.products.isEmpty else {
//            print("Found 0 products")
//            return
//        }
//
//        for product in response.products {
//            print("FOund product: \(product.productIdentifier)")
//        }
//    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load products with error:\n \(error)")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                transactionState = .purchasing
            case .purchased:
                queue.finishTransaction(transaction)
                transactionState = .purchased
                print("Transaction Successful")
            case .restored:
                queue.finishTransaction(transaction)
                transactionState = .restored
                print("Покупка возвращена")
            case .failed, .deferred:
                transactionState = .failed
                print("Transaction Failed")
            default:
                queue.finishTransaction(transaction)
            }
        }
        
    }
    

}


