import UIKit


class CustomMenuButton: UIButton {
    
    private let titleLbl = UILabel()
    private let chevronImageView = UIImageView()
    private let contentStack = UIStackView()
    private var actions: [UIAction] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        // Border olib tashlandi, background o‘zgartirildi
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 12
        self.backgroundColor = .secondarySystemBackground
        self.clipsToBounds = true

        // Label
        titleLbl.font = UIFont.systemFont(ofSize: 16)
        titleLbl.textColor = .label
        titleLbl.isUserInteractionEnabled = false

        // Chevron
        chevronImageView.image = UIImage(systemName: "chevron.down")
        chevronImageView.tintColor = .systemGray
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.isUserInteractionEnabled = false

        // Stack
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.distribution = .equalSpacing
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.isUserInteractionEnabled = false

        contentStack.addArrangedSubview(titleLbl)
        contentStack.addArrangedSubview(chevronImageView)

        self.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            contentStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            contentStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        self.showsMenuAsPrimaryAction = true
    }

    // Matnni o‘rnatish
    func setTitle(_ text: String) {
        self.titleLbl.text = text
    }

    // Menu itemlarini tashqaridan uzatish
    func setMenuItems(titles: [String]) {
        let newActions = titles.map { title in
            UIAction(title: title, handler: { [weak self] _ in
                self?.setTitle(title)
            })
        }

        self.actions = newActions
        let menu = UIMenu(children: newActions)
        self.menu = menu
    }
}




class CustomButton: UIButton {
    
    private let titleLbl = UILabel()
    private let chevronImageView = UIImageView()
    
    // Paddinglar uchun stack view ishlatamiz
    private let contentStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // Button border va stil
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        // Matn stili
        titleLbl.font = UIFont.customFont(.regular, 16)
        titleLbl.textColor = .label
        
        // Chevron rasmi (SF Symbols)
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .systemGray
        chevronImageView.contentMode = .scaleAspectFit
        titleLbl.isUserInteractionEnabled = false
        chevronImageView.isUserInteractionEnabled = false
        contentStack.isUserInteractionEnabled = false
        
        // Stack view
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.distribution = .equalSpacing
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentStack.addArrangedSubview(titleLbl)
        contentStack.addArrangedSubview(chevronImageView)
        
        self.addSubview(contentStack)
        
        // Auto Layout
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            contentStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            contentStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    // Oson nom berish uchun funksiyasi
    func setTitle(_ text: String) {
        self.titleLbl.text = text
    }
}
