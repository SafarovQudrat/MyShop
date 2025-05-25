import UIKit

class ProductsVC: UIViewController {
    private var backV: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGroupedBackground
        v.layer.cornerRadius = 12
        return v
    }()
    var tableView: UITableView = {
        let t = UITableView()
        t.backgroundColor = .clear
        t.register(UINib(nibName: "SaleTVC", bundle: nil), forCellReuseIdentifier: "SaleTVC")
        return t
    }()
    private var addProductBtn: CustomButton = {
        let b = CustomButton()
        b.setTitle("Mahsulot qo'shish")
        return b
    }()
    let searchController = UISearchController(searchResultsController: nil)
    var products:[ProductCD] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apparenceSettings()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        products = CoreDataManager.shared.fetchProducts()
        tableView.reloadData()
    }
    
    func apparenceSettings() {
        view.backgroundColor = #colorLiteral(red: 0.1214147285, green: 0.2226163745, blue: 0.3583123684, alpha: 1)
        view.addSubview(backV)
        backV.addSubview(tableView)
        self.navigationItem.backButtonTitle = ""
        backV.addSubview(addProductBtn)
        title = "Mahsulotlar"
        tableView.delegate = self
        tableView.dataSource = self
        addProductBtn.addTarget(self, action: #selector(addProductTapped), for: .touchUpInside)
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
        addProductBtn.snp.makeConstraints { make in
            make.top.equalTo(backV.snp_topMargin).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addProductBtn.snp_bottomMargin).offset(12)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func addProductTapped() {
        let vc = AddProductVC()
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}
