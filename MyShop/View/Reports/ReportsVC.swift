import UIKit

class ReportsVC: UIViewController {

    private var backV: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGroupedBackground
        v.layer.cornerRadius = 12
        return v
    }()
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Haftalik", "Oylik", "Yillik"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    var filteredProducts: [ProductCD] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hisobot"
        view.backgroundColor = #colorLiteral(red: 0.1214147285, green: 0.2226163745, blue: 0.3583123684, alpha: 1)
        view.addSubview(backV)

        backV.addSubview(segmentedControl)
        backV.addSubview(tableView)

        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        setupConstraints()
        filterProducts()
    }

    func setupConstraints() {
        
        backV.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalTo(0)
        }
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func segmentChanged() {
        filterProducts()
    }

    func filterProducts() {
        let allProducts = CoreDataManager.shared.fetchProducts()
        let now = Date()
        let calendar = Calendar.current

        let fromDate: Date
        switch segmentedControl.selectedSegmentIndex {
        case 0: fromDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case 1: fromDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case 2: fromDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        default: fromDate = now
        }

        filteredProducts = allProducts.filter { $0.addedDate ?? now >= fromDate }
        tableView.reloadData()
    }
}

extension ReportsVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredProducts.isEmpty {
            tableView.showEmptyMessage("Ma'lumot yo‘q")
        } else {
            tableView.hideEmptyMessage()
        }
        return filteredProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = filteredProducts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0

        let sotilgan = Int(product.totalProduct - product.remainingP)
        let qolgan = Int(product.remainingP)
        let summa = Double(sotilgan) * product.salePrice
        let foyda = Double(sotilgan) * (product.salePrice - product.purchasePrice)

        cell.textLabel?.text = """
        \(product.name ?? "Noma'lum")
        Sotilgan: \(sotilgan), Qolgan: \(qolgan)
        Summa: \(Int(summa)), Foyda: \(Int(foyda))
        """
        return cell
    }
}
