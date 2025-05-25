import UIKit

extension UIViewController {
    func showLanguageSelection() {
        let alertController = UIAlertController(title: nil, message: "Choose Language", preferredStyle: .actionSheet)
        
        let englishAction = UIAlertAction(title: "English", style: .default) { _ in
            print("Language set to EN")
        }
        let uzbekAction = UIAlertAction(title: "Uzbek", style: .default) { _ in
            print("Language set to UZ")
        }
        let russianAction = UIAlertAction(title: "Russian", style: .default) { _ in
            print("Language set to RU")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(englishAction)
        alertController.addAction(uzbekAction)
        alertController.addAction(russianAction)
        alertController.addAction(cancelAction)

        // iPad uchun (agar kerak bo‘lsa)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(alertController, animated: true)
    }
}
