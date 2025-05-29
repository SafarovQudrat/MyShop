import UIKit

extension ProfileVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationItem.backButtonTitle = ""
      switch Items.allCases[indexPath.row] {
            
      case .qoldiq:
          let vc = RemainingVC()
          self.navigationController?.pushViewController(vc, animated: true)
      case .tarix:
          let vc = SaleHistoryVC()
          self.navigationController?.pushViewController(vc, animated: true)
      case .qarz:
          let vc = DebtsVC()
          self.navigationController?.pushViewController(vc, animated: true)
      case .hisobot:
          let vc = ReportsVC()
          self.navigationController?.pushViewController(vc, animated: true)
      case .til:
          showLanguageSelection()
      case .share:
          print("Share Tapped")
      case .aboutus:
          print("About us Tapped")
      case .logOut:
          if let window = UIApplication.shared.windows.first {
              UserDefaults.standard.removeObject(forKey: "dataFetched")
              CoreDataManager.shared.deleteAllCoreData()
              cache.set(false, forKey: "isTabbar")
                 window.rootViewController = UINavigationController(rootViewController: LoginVC())
                 window.makeKeyAndVisible()
             }
      }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Items.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVC") as? ProfileTVC else {return UITableViewCell()}
        cell.nameLbl.text = Items.allCases[indexPath.row].rawValue
        return cell
    }
    
    
}
