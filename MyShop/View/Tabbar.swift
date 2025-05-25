import UIKit

class Tabbar: UITabBarController {
    let vc1 = SaleVC()
    let vc2 = ProductsVC()
    let vc3 = ProfileVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc1.tabBarItem = UITabBarItem(title: "Sale", image: UIImage(systemName: "cart"), tag: 0)
        vc2.tabBarItem = UITabBarItem(title: "Products", image: UIImage(systemName: "cube"), tag: 1)
        vc3.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)
        let apparence = UITabBarAppearance()
        apparence.backgroundColor = .systemBackground
        self.tabBar.scrollEdgeAppearance = apparence
        self.tabBar.standardAppearance = apparence
        self.viewControllers = [CustomNavigationController(rootViewController: vc1),CustomNavigationController(rootViewController: vc2),CustomNavigationController(rootViewController: vc3)]
    }
}
