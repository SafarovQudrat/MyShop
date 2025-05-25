import UIKit

class RemainingVC: UIViewController {
    
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
    var remainingProducts: [ProductCD] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Qolgan mahsulotlar"
        view.backgroundColor = #colorLiteral(red: 0.1214147285, green: 0.2226163745, blue: 0.3583123684, alpha: 1)
        view.addSubview(backV)
        backV.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        backV.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalTo(0)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalTo(0)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        remainingProducts = CoreDataManager.shared.fetchProducts()
        tableView.reloadData()
    }
    
}
