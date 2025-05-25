import UIKit


class AllProductsVC: UIViewController {
    private var backV: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGroupedBackground
        v.layer.cornerRadius = 12
        return v
    }()
    private var tableView : UITableView = {
        let t = UITableView()
        t.backgroundColor = .clear
        t.register(UINib(nibName: "SaleTVC", bundle: nil), forCellReuseIdentifier: "SaleTVC")
        return t
    }()
    let searchController = UISearchController(searchResultsController: nil)
    var getProduct: ((ProductCD)->Void)?
    var products:[ProductCD] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        apparenceSettings()
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        products = CoreDataManager.shared.fetchProducts()
    }
    
    func apparenceSettings() {
        tableView.delegate = self
        tableView.dataSource = self
        title = "Mahsulotlar"
        view.backgroundColor = #colorLiteral(red: 0.1214147285, green: 0.2226163745, blue: 0.3583123684, alpha: 1)
        view.addSubview(backV)
        backV.addSubview(tableView)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Qidirish..."
        let searchBar = searchController.searchBar
            searchBar.searchTextField.backgroundColor = .systemGroupedBackground
            searchBar.searchTextField.textColor = .label
            searchBar.barTintColor = .systemBackground
            searchBar.tintColor = .label
        navigationItem.searchController = searchController
        definesPresentationContext = true
        backV.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalTo(0)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalTo(0)
        }
       
    }
    
    
    
}

extension AllProductsVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        print("Qidirilmoqda: \(query)")
    }
}

extension AllProductsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getProduct?(products[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if products.isEmpty {
            tableView.showEmptyMessage("Mahsulot yo‘q")
        } else {
            tableView.hideEmptyMessage()
        }
       return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SaleTVC", for: indexPath) as? SaleTVC else {return UITableViewCell()}
        cell.totalCostLbl.isHidden = true
        cell.deleteBtn.isHidden = true
        cell.stepper.isHidden = true
        cell.sumLbl.isHidden = true
        cell.configureAllProducts(product: products[indexPath.row])
        return cell
    }
    
    
}
