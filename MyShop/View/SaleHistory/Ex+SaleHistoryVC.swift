import UIKit

extension SaleHistoryVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if history.isEmpty {
            tableView.showEmptyMessage("Ma'lumot yo‘q")
        } else {
            tableView.hideEmptyMessage()
        }
       return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SaleTVC") as? SaleTVC else {return UITableViewCell()}
        cell.totalCostLbl.isHidden = true
        cell.deleteBtn.isHidden = true
        cell.stepper.isHidden = true
        cell.sumLbl.textColor = .red
        cell.nameLbl.numberOfLines = 0
        cell.nameLbl.font = .customFont(.regular, 16)
        cell.costLbl.textColor = .gray
        
        let products =  ( history[indexPath.row].products as? Set<ProductCD>)?.map { $0 } ?? []
        cell.configureSaleHistory(sale: products,date:history[indexPath.row].date ?? Date(), summ: history[indexPath.row].totalCost)
        return cell
    }
    
    
}
