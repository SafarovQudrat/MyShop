import UIKit
import SnapKit
import Firebase
class SaleVC: UIViewController {
    private var backV: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGroupedBackground
        v.layer.cornerRadius = 12
        return v
    }()
    private var qrBtn: UIButton = {
        let b = UIButton()
       b.setBackgroundImage(UIImage(systemName: "barcode.viewfinder"), for: .normal)
       b.tintColor = .gray
        return b
    }()
    private var addProductBtn: CustomButton = {
        let b = CustomButton()
        b.setTitle("Mahsulot qo'shish")
        return b
    }()
    var tableView: UITableView = {
        let t = UITableView()
        
        t.backgroundColor = .clear
        t.register(UINib(nibName: "SaleTVC", bundle: nil), forCellReuseIdentifier: "SaleTVC")
        return t
    }()
    var costView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        return v
    }()
    private var totalCostLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.text = "Jami:"
        lbl.font = .customFont(.medium, 17)
        return lbl
    }()
     var costLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.text = "0 so'm"
        lbl.font = .customFont(.medium, 17)
        return lbl
    }()
    lazy var costStackV: UIStackView = {
        let s = UIStackView(arrangedSubviews: [totalCostLbl,costLbl])
        s.axis = .horizontal
        s.spacing = 0
        s.alignment = .fill
        s.distribution = .equalSpacing
        return s
    }()
    var products = EachSale(saleProducts: [], foyda: 0, summ: 0)
    var soldProducts: [ProductCD] = []
    var totalPrice:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataOnceIfNeeded()
        apparenceSettings()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func apparenceSettings(){
        tableView.delegate = self
        tableView.dataSource = self
        title = "Sotish"
        view.backgroundColor = #colorLiteral(red: 0.1214147285, green: 0.2226163745, blue: 0.3583123684, alpha: 1)
        view.addSubview(backV)
        backV.addSubview(qrBtn)
        backV.addSubview(addProductBtn)
        backV.addSubview(tableView)
        backV.addSubview(costView)
        costView.addSubview(costStackV)
        qrBtn.addTarget(self, action: #selector(qrBtnTapped), for: .touchUpInside)
        let saleBtn = UIBarButtonItem(title: "Sale", style: .done, target: self, action: #selector(saleTapped))
        self.navigationItem.rightBarButtonItem = saleBtn
        self.navigationItem.backButtonTitle = ""
        addProductBtn.addTarget(self, action: #selector(addProductTapped), for: .touchUpInside)
        backV.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalTo(0)
        }
        qrBtn.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.top.equalTo(24)
            make.centerX.equalTo(view.snp_centerXWithinMargins)
        }
        addProductBtn.snp.makeConstraints { make in
            make.top.equalTo(qrBtn.snp_bottomMargin).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        costView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        costStackV.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.centerY.equalTo(costView.snp_centerYWithinMargins)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addProductBtn.snp_bottomMargin).offset(12)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func addProductTapped() {
        let vc = AllProductsVC()
        self.navigationController?.pushViewController(vc, animated: true)
        vc.getProduct = { [self] product in
            if let index = products.saleProducts.firstIndex(where: { $0.barcode == product.barcode }) {
                products.saleProducts[index].count += 1
            } else {
                products.saleProducts.append(Product(barcode: product.barcode!, count: 1))
            }
            updateTotalCost()
            tableView.reloadData()
        }
    }
    @objc func qrBtnTapped(){
        let vc = ReadBarcodeVC()
       
        vc.getCode = { [self] barcode in
            let matchedProducts = CoreDataManager.shared.fetchProducts().filter { $0.barcode == barcode }
            if matchedProducts.isEmpty {showInfoAlert(title: "Xatolik", message: "Bunday maxsulot topilmadi")}

            for product in matchedProducts {
                if let index = products.saleProducts.firstIndex(where: { $0.barcode == product.barcode }) {
                    products.saleProducts[index].count += 1
                } else {
                    products.saleProducts.append(Product(barcode: product.barcode!, count: 1))
                }
            }

            updateTotalCost()
            tableView.reloadData()
        }
        present(vc, animated: true)
    }
    
    @objc func saleTapped() {
        CoreDataManager.shared.addSale(from: products)
        FirebaseManager.shared.addSale(date: Date(), foyda: products.foyda, totalCost: products.summ, saleProducts: products.saleProducts) { error in
            print("add sale error \(String(describing: error?.localizedDescription))")
        }
        showInfoAlert(title: "Success", message: "Maxsulot sotildi!")
        products.saleProducts = []
        totalCostLbl.text = "0 so'm"
        tableView.reloadData()
    }
    
    
    func fetchDataOnceIfNeeded() {
        let hasFetched = UserDefaults.standard.bool(forKey: "dataFetched")

        guard !hasFetched else {
            print("Ma'lumotlar allaqachon olingan.")
            return
        }

        let db = Firestore.firestore()
        let group = DispatchGroup()

        // 1. Products
        group.enter()
        db.collection("products").getDocuments(completion: { snapshot, error in
            if let error = error {
                print("Products xatosi: \(error)")
                group.leave()
                return
            }

            snapshot?.documents.forEach { doc in
                let data = doc.data()
                CoreDataManager.shared.addProduct(
                    barcode: (data["barcode"] as? String) ?? "",
                    category: data["category"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    purchasePrice: data["purchasePrice"] as? Double ?? 0 ,
                    salePrice: data["salePrice"] as? Double ?? 0 ,
                    totalProduct: Int64(data["totalProduct"] as? Double ?? 0),
                    unitType: data["unitType"] as? String ?? "",
                    validityPeriod: data["validityPeriod"] as? Date ?? Date()
                )
            }

            print("Products yuklandi.")
            group.leave()
        })

        // 2. Sales
        group.enter()
        db.collection("sales").getDocuments(completion: { snapshot, error in
            if let error = error {
                print("Sales xatosi: \(error)")
                group.leave()
                return
            }

            snapshot?.documents.forEach { doc in
                let data = doc.data()
                
                if let productDicts = data["products"] as? [[String: Any]] {
                    var products: [Product] = []
                    for dict in productDicts {
                        let product = Product(barcode: dict["product"] as! String,count: dict["count"] as! Int)
                        products.append(product)
                    }

                    let eachSale = EachSale(
                        saleProducts: products,
                        foyda: data["foyda"] as? Double ?? 0.0,
                        summ: data["summ"] as? Double ?? 0.0
                    )

                    CoreDataManager.shared.addSale(from: eachSale)
                }
            }

            print("Sales yuklandi.")
            group.leave()
        })


        // 3. Debts
        group.enter()
        db.collection("debts").getDocuments { snapshot, error in
            if let error = error {
                print("Debts xatosi: \(error)")
                group.leave()
                return
            }

            snapshot?.documents.forEach { doc in
                let data = doc.data()
                CoreDataManager.shared.addDebts(
                    name: data["name"] as? String ?? "",
                    amount: data["amount"] as? Double ?? 0.0,
                    debtDate: (data["debtDate"] as? Timestamp)?.dateValue() ?? Date()
                )
            }

            print("Debts yuklandi.")
            group.leave()
        }

        // Barchasi tugagach
        group.notify(queue: .main) {
            UserDefaults.standard.set(true, forKey: "dataFetched")
            print("Barcha ma'lumotlar saqlandi va flag o'rnatildi.")
        }
    }

    
}


