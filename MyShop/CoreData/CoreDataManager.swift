import UIKit
import CoreData

class CoreDataManager {
    
    public static let shared = CoreDataManager()
    
    private init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    MARK: Products
    
    func addProduct(barcode: String, category: String, name: String, purchasePrice: Double, salePrice: Double, totalProduct: Int64, unitType: String, validityPeriod: Date) {
        guard let productEntity = NSEntityDescription.entity(forEntityName: "ProductCD", in: context) else { return }
        let product = ProductCD(entity: productEntity, insertInto: context)
        product.barcode = barcode
        product.category = category
        product.name = name
        product.purchasePrice = purchasePrice
        product.salePrice = salePrice
        product.totalProduct = totalProduct
        product.unitType = unitType
        product.validityPeriod = validityPeriod
        product.addedDate = Date()
        appDelegate.saveContext()
    }
    
    func fetchProducts() -> [ProductCD] {
        let request: NSFetchRequest<ProductCD> = ProductCD.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
            return []
        }
    }
    func updateProduct(_ product: ProductCD,category: String,barcode: String, name: String, purchasePrice: Double, salePrice: Double, totalProduct: Int64, unitType: String, validityPeriod: Date) {
        product.barcode = barcode
        product.category = category
        product.name = name
        product.purchasePrice = purchasePrice
        product.salePrice = salePrice
        product.totalProduct = totalProduct
        product.unitType = unitType
        product.validityPeriod = validityPeriod
        appDelegate.saveContext()
    }
    
    func deleteProduct(_ product: ProductCD) {
        context.delete(product)
        appDelegate.saveContext()
    }
    
//    MARK: Debts

    func addDebts(name: String,amount: Double, debtDate: Date) {
        guard let productEntity = NSEntityDescription.entity(forEntityName: "Debts", in: context) else { return }
        let debts = Debts(entity: productEntity, insertInto: context)
        debts.date = debtDate
        debts.name = name
        debts.summ = amount
        appDelegate.saveContext()
    }
    
    func fetchDebts() -> [Debts] {
        let request: NSFetchRequest<Debts> = Debts.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
            return []
        }
    }
    
    func updateDebt(_ debt: Debts, newName: String, newAmount: Double) {
        debt.name = newName
        debt.summ = newAmount
        appDelegate.saveContext()
    }
    
    
    func deleteDebts(_ debt: Debts) {
        context.delete(debt)
        appDelegate.saveContext()
    }
//    MARK: Sale
    
    func addSale(from eachSale: EachSale) {
        guard let saleEntity = NSEntityDescription.entity(forEntityName: "SaleCD", in: context) else { return }
        let sale = SaleCD(entity: saleEntity, insertInto: context)

        let products = eachSale.saleProducts.map { $0.product }
        sale.products = NSSet(array: products)
        sale.date = Date()
        sale.foyda = eachSale.foyda
        sale.totalCost = eachSale.summ

        // Ombordagi maxsulot sonini yangilash
        for saleItem in eachSale.saleProducts {
            saleItem.product.totalProduct -= Int64(saleItem.count)
        }

        appDelegate.saveContext()
    }

    
    func fetchSale() -> [SaleCD] {
        let request: NSFetchRequest<SaleCD> = SaleCD.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteSale(_ sale: SaleCD) {
        context.delete(sale)
        appDelegate.saveContext()
    }
}
