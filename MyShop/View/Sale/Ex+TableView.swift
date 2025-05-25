import UIKit

extension SaleVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if products.saleProducts.isEmpty {
            tableView.showEmptyMessage("Ma'lumot yo‘q")
        } else {
            tableView.hideEmptyMessage()
        }
        return products.saleProducts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SaleTVC", for: indexPath) as? SaleTVC else {return UITableViewCell()}
        cell.delegate = self
        cell.configureSale(product: products.saleProducts[indexPath.row].product, count: products.saleProducts[indexPath.row].count)
        
        return cell
    }
}

extension SaleVC: SaleTVCDelegate {
    func didChangeStepperValue(_ cell: SaleTVC, value: Int) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        products.saleProducts[indexPath.row].count = value
        tableView.reloadRows(at: [indexPath], with: .automatic)
        updateTotalCost()
    }

    func didTapDelete(_ cell: SaleTVC) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        products.saleProducts.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        updateTotalCost()
    }

    func updateTotalCost() {
        let total = products.saleProducts.reduce(0) { $0 + (Int($1.product.salePrice) * $1.count) }
        let totalSold = products.saleProducts.reduce(0) { $0 + (Int($1.product.purchasePrice) * $1.count) }
        products.foyda = Double(total - totalSold)
        products.summ = Double(total)
        costLbl.text = "\(total) so'm"
    }
}
