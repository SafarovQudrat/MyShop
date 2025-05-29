import UIKit

class DebtsVC: UIViewController {
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
    var debts:[Debts] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apparenceSettings()
    }
    override func viewWillAppear(_ animated: Bool) {
        debts = CoreDataManager.shared.fetchDebts()
        tableView.reloadData()
    }
    
    func apparenceSettings() {
        
        title = "Qarzlar"
        view.backgroundColor = #colorLiteral(red: 0.1214147285, green: 0.2226163745, blue: 0.3583123684, alpha: 1)
        view.addSubview(backV)
        backV.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        let addBtn = UIBarButtonItem(title: "Qo'shish", style: .done, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addBtn
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
    
    func showAddDebtAlert(onSave: @escaping (String, String) -> Void) {
        let alert = UIAlertController(title: "Yangi qarz qo‘shish", message: "", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Qarz egasi (ism)"
        }

        alert.addTextField { textField in
            textField.placeholder = "Qarz miqdori (so‘m)"
            textField.keyboardType = .numberPad
        }

        let saveAction = UIAlertAction(title: "Saqlash", style: .default) { _ in
            let name = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let amount = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            if name.isEmpty || amount.isEmpty {
                // Alertni yopmasdan, ogohlantirish
                alert.message = "Iltimos, barcha maydonlarni to‘ldiring!"
                self.present(alert, animated: true)
            } else {
                onSave(name, amount)
            }
        }

        let cancelAction = UIAlertAction(title: "Bekor qilish", style: .cancel)

        alert.addAction(cancelAction)
        alert.addAction(saveAction)

        self.present(alert, animated: true)
    }

    func showEditAlert(_ name: String,_ amount: String, onSave: @escaping (String,String) -> Void) {
        let alert = UIAlertController(title: "Tahrirlash", message: "Matnni yangilang", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = name
        }
        alert.addTextField { textField in
            textField.text = amount
        }
        
        let saveAction = UIAlertAction(title: "Saqlash", style: .default) { _ in
            let name = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let amount = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            if name.isEmpty || amount.isEmpty {
                // Alertni yopmasdan, ogohlantirish
                alert.message = "Iltimos, barcha maydonlarni to‘ldiring!"
                self.present(alert, animated: true)
            } else {
                onSave(name, amount)
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Bekor qilish", style: .cancel))
        
        present(alert, animated: true)
    }

    @objc func addTapped() {
        showAddDebtAlert { [self] name, amount in
            CoreDataManager.shared.addDebts(name: name, amount: Double(amount) ?? 0, debtDate: Date())
            FirebaseManager.shared.addDebt(name: name, amount: Double(amount) ?? 0, debtDate: Date()) { result in
                print("Add debt error \(String(describing: result?.localizedDescription))")
            }
            debts = CoreDataManager.shared.fetchDebts()
            tableView.reloadData()
        }
    }
    
}

