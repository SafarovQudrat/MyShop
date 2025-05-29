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
        product.remainingP = totalProduct
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
    
    func deleteAllCoreData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let entities = ["Product", "Debt", "Sale"] // Entity nomlari

        for entityName in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(deleteRequest)
                try context.save()
                print("\(entityName) uchun barcha ma'lumotlar o'chirildi.")
            } catch {
                print("Xatolik \(entityName) ni o'chirishda: \(error)")
            }
        }
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

        // barcode lar orqali mos keluvchi ProductCD larni topish
        var productObjects: [ProductCD] = []

        for saleItem in eachSale.saleProducts {
            let barcode = saleItem.barcode
            let fetchRequest: NSFetchRequest<ProductCD> = ProductCD.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "barcode == %@", barcode)

            if let result = try? context.fetch(fetchRequest), let product = result.first {
                productObjects.append(product)
            }
        }

        sale.products = NSSet(array: productObjects)
        sale.date = Date()
        sale.foyda = eachSale.foyda
        sale.totalCost = eachSale.summ

        for saleItem in eachSale.saleProducts {
            let barcode = saleItem.barcode
            let countToSubtract = Int64(saleItem.count)

            let fetchRequest: NSFetchRequest<ProductCD> = ProductCD.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "barcode == %@", barcode)

            if let result = try? context.fetch(fetchRequest), let product = result.first {
                product.remainingP -= countToSubtract
            }
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
