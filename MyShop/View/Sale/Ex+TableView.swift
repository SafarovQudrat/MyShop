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
        let targetBarcode = products.saleProducts[indexPath.row].barcode
        let allProducts = CoreDataManager.shared.fetchProducts()
        soldProducts = allProducts.filter { $0.barcode == targetBarcode }

        cell.configureSale(product: soldProducts[indexPath.row], count: products.saleProducts[indexPath.row].count)
        
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
        
        let total = soldProducts.reduce(into: 0) { $0 + (Int($1.salePrice) * Int($1.count)) }
        let totalSold = soldProducts.reduce(into: 0) { $0 + (Int($1.purchasePrice) * Int($1.count)) }
        products.foyda = Double(total - totalSold)
        products.summ = Double(total)
        costLbl.text = "\(total) so'm"
    }
}
