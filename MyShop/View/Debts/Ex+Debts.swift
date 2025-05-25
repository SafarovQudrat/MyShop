import UIKit

extension DebtsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let selectedText = data[indexPath.row] // data - sizning massiv
        let actionSheet = UIAlertController(title: "Amalni tanlang", message: nil, preferredStyle: .actionSheet)

        // Tahrirlash
        actionSheet.addAction(UIAlertAction(title: "Tahrirlash", style: .default, handler: { [self] _ in
            showEditAlert(debts[indexPath.row].name ?? "", "\(debts[indexPath.row].summ)") { [self] name, amount in
                CoreDataManager.shared.updateDebt(debts[indexPath.row], newName: name, newAmount: Double(amount) ?? 0)
                debts = CoreDataManager.shared.fetchDebts()
                tableView.reloadData()
            }
        }))

        // O‘chirish
        actionSheet.addAction(UIAlertAction(title: "O‘chirish", style: .destructive, handler: { [self] _ in
            CoreDataManager.shared.deleteDebts(debts[indexPath.row])
            debts = CoreDataManager.shared.fetchDebts()
            tableView.reloadData()
        }))

        // Bekor qilish
        actionSheet.addAction(UIAlertAction(title: "Bekor qilish", style: .cancel))


        present(actionSheet, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if debts.isEmpty {
            tableView.showEmptyMessage("Ma'lumot yo‘q")
        } else {
            tableView.hideEmptyMessage()
        }
        return debts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SaleTVC") as? SaleTVC else {return UITableViewCell()}
        cell.nameLbl.font = .customFont(.medium, 17)
        cell.costLbl.font = .customFont(.regular, 14)
        cell.totalCostLbl.font = .customFont(.regular, 12)
        cell.totalCostLbl.textColor = .systemGray
        cell.sumLbl.isHidden = true
        cell.deleteBtn.isHidden = true
        cell.stepper.isHidden = true
        cell.configureDebts(debt: debts[indexPath.row])
        return cell
    }
    
    
}
