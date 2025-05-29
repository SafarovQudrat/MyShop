import UIKit

extension ProductsVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let actionSheet = UIAlertController(title: "Amalni tanlang", message: nil, preferredStyle: .actionSheet)

        // Tahrirlash
        actionSheet.addAction(UIAlertAction(title: "Tahrirlash", style: .default, handler: { [self] _ in
           let vc = AddProductVC()
            vc.isEdit = true
            vc.product = self.products[indexPath.row]

            self.navigationController?.pushViewController(vc, animated: true)
        }))

        // O‘chirish
        actionSheet.addAction(UIAlertAction(title: "O‘chirish", style: .destructive, handler: { [self] _ in
            CoreDataManager.shared.deleteProduct(products[indexPath.row])
            FirebaseManager.shared.deleteProduct(productId: products[indexPath.row].name!) { error in
                print("Delete product error \(String(describing: error?.localizedDescription))")
            }
            products = CoreDataManager.shared.fetchProducts()
            tableView.reloadData()
        }))

        // Bekor qilish
        actionSheet.addAction(UIAlertAction(title: "Bekor qilish", style: .cancel))


        present(actionSheet, animated: true)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if products.isEmpty {
            tableView.showEmptyMessage("Ma'lumot yo‘q")
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
        cell.configureAllProducts(product: products[indexPath.row])
        return cell
    }
    
    
}

extension ProductsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        print("Qidirilmoqda: \(query)")
    }
}
