import UIKit

extension UIViewController {
    func showAlert(_ title: String, _ message: String, completion: @escaping ((Bool?) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in
            completion(true)
        }))
        present(alert, animated: true)
    }
    
    func showInfoAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showTxtAlert(_ title: String, completion: @escaping ((String?,Bool?) -> Void)) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alert.addAction(UIAlertAction(title: "Save", style: .default,handler: { _ in
            if alert.textFields?.first?.text ?? "" != "" {
                completion(alert.textFields?.first?.text, true)
            }else {completion(nil,false)}
            
        }))
        present(alert, animated: true)
    }
}
