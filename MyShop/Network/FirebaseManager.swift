import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class FirebaseManager {
    static let shared = FirebaseManager()

    private let auth: Auth
    private let db: Firestore

    private init() {
        self.auth = Auth.auth()
        self.db = Firestore.firestore()
    }

    // MARK: - Register
    func register(email: String, password: String, shopName: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                let userData: [String: Any] = [
                    "email": email,
                    "shopName": shopName,
                    "uid": user.uid,
                    "createdAt": FieldValue.serverTimestamp()
                ]
                self.db.collection("users").document(user.uid).setData(userData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(user))
                    }
                }
            }
        }
    }

    // MARK: - Login
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }

    // MARK: - Products CRUD

    func addProduct(barcode: String, category: String, name: String, purchasePrice: Double, salePrice: Double, totalProduct: Int64, unitType: String, validityPeriod: Date, completion: @escaping (Error?) -> Void) {
        let productData: [String: Any] = [
            "barcode": barcode,
            "category": category,
            "name": name,
            "purchasePrice": purchasePrice,
            "salePrice": salePrice,
            "totalProduct": totalProduct,
            "unitType": unitType,
            "validityPeriod": Timestamp(date: validityPeriod),
            "addedDate": FieldValue.serverTimestamp()
        ]
        db.collection("products").addDocument(data: productData) { error in
            completion(error)
        }
    }

    func fetchProducts(completion: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
        db.collection("products").getDocuments { snapshot, error in
            completion(snapshot?.documents, error)
        }
    }

    func updateProduct(productId: String, barcode: String, category: String, name: String, purchasePrice: Double, salePrice: Double, totalProduct: Int64, unitType: String, validityPeriod: Date, completion: @escaping (Error?) -> Void) {
        let updatedData: [String: Any] = [
            "barcode": barcode,
            "category": category,
            "name": name,
            "purchasePrice": purchasePrice,
            "salePrice": salePrice,
            "totalProduct": totalProduct,
            "unitType": unitType,
            "validityPeriod": Timestamp(date: validityPeriod)
        ]
        db.collection("products").document(productId).updateData(updatedData) { error in
            completion(error)
        }
    }

    func deleteProduct(productId: String, completion: @escaping (Error?) -> Void) {
        db.collection("products").document(productId).delete { error in
            completion(error)
        }
    }

    // MARK: - Debts CRUD

    func addDebt(name: String, amount: Double, debtDate: Date, completion: @escaping (Error?) -> Void) {
        let debtData: [String: Any] = [
            "name": name,
            "summ": amount,
            "date": Timestamp(date: debtDate)
        ]
        db.collection("debts").addDocument(data: debtData) { error in
            completion(error)
        }
    }

    func fetchDebts(completion: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
        db.collection("debts").getDocuments { snapshot, error in
            completion(snapshot?.documents, error)
        }
    }

    func updateDebt(debtId: String, newName: String, newAmount: Double, completion: @escaping (Error?) -> Void) {
        let updatedData: [String: Any] = [
            "name": newName,
            "summ": newAmount
        ]
        db.collection("debts").document(debtId).updateData(updatedData) { error in
            completion(error)
        }
    }

    func deleteDebt(debtId: String, completion: @escaping (Error?) -> Void) {
        db.collection("debts").document(debtId).delete { error in
            completion(error)
        }
    }

    // MARK: - Sales CRUD

    // Note: EachSale va saleProducts tuzilmasini to‘liq bilmasam ham, umumiy tuzilma asosida yozdim.
    // saleProducts ichida productId va count bor deb taxmin qildim.

    func addSale(date: Date, foyda: Double, totalCost: Double, saleProducts: [Product], completion: @escaping (Error?) -> Void) {

        // Sale document data
        let saleData: [String: Any] = [
            "date": Timestamp(date: date),
            "foyda": foyda,
            "totalCost": totalCost,
            "products": saleProducts.map { ["productId": $0.barcode, "count": $0.count] }
        ]

        db.collection("sales").addDocument(data: saleData) { error in
            if let error = error {
                completion(error)
            } else {
                // Update totalProduct count in products collection
                let batch = self.db.batch()
                for saleProduct in saleProducts {
                    let productRef = self.db.collection("products").document(saleProduct.barcode)
                    batch.updateData(["totalProduct": FieldValue.increment(Int64(-saleProduct.count))], forDocument: productRef)
                }
                batch.commit { batchError in
                    completion(batchError)
                }
            }
        }
    }

    func fetchSales(completion: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
        db.collection("sales").getDocuments { snapshot, error in
            completion(snapshot?.documents, error)
        }
    }

    func deleteSale(saleId: String, completion: @escaping (Error?) -> Void) {
        db.collection("sales").document(saleId).delete { error in
            completion(error)
        }
    }
}
