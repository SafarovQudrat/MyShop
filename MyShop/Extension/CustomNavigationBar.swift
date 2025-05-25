import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = .white // bu back button va boshqa tugmalar uchun

        // Back tugmasi uchun default image o‘rnatilsa bo‘ladi (ixtiyoriy)
        // navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")
        // navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")
    }
}
