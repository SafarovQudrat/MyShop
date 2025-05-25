import UIKit

extension UIView {
    func addShadow(_ radius: CGFloat){
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
}

extension UITableView {
    func showEmptyMessage(_ message: String) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.font = .systemFont(ofSize: 18, weight: .medium)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func hideEmptyMessage() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
