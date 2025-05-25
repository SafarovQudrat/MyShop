import UIKit


class LoaderView: UIView {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        layer.cornerRadius = 10
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func show(in view: UIView) {
        frame = view.bounds
        view.addSubview(self)
        activityIndicator.startAnimating()
    }

    func hide() {
        activityIndicator.stopAnimating()
        removeFromSuperview()
    }
}

private var loaderKey: UInt8 = 0

extension UIViewController {
    
    private var loaderView: LoaderView? {
        get {
            return objc_getAssociatedObject(self, &loaderKey) as? LoaderView
        }
        set {
            objc_setAssociatedObject(self, &loaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showLoader() {
        if loaderView == nil {
            let loader = LoaderView()
            loaderView = loader
            loader.show(in: self.view)
        }
    }
    
    func hideLoader() {
        loaderView?.hide()
        loaderView = nil
    }
}
