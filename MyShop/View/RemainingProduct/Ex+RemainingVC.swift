import UIKit

extension RemainingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if remainingProducts.isEmpty {
            tableView.showEmptyMessage("Ma'lumot yo‘q")
        } else {
            tableView.hideEmptyMessage()
        }
        return remainingProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SaleTVC") as? SaleTVC else {return UITableViewCell()}
        cell.totalCostLbl.isHidden = true
        cell.costLbl.isHidden = true
        cell.deleteBtn.isHidden = true
        cell.stepper.isHidden = true
        cell.nameLbl.text = remainingProducts[indexPath.row].name
        cell.sumLbl.text = "\(remainingProducts[indexPath.row].totalProduct) \(remainingProducts[indexPath.row].unitType ?? "")"
        return cell
    }
    
    
}
