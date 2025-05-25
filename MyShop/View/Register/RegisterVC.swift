import UIKit
var cache = UserDefaults.standard

class RegisterVC: UIViewController {
    
    private var logoImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.image = UIImage(systemName: "cart.fill")
        v.tintColor = UIColor.systemIndigo
        return v
    }()
    private var logoTextLabel: UILabel = {
        let v = UILabel()
        v.text = "My Shop"
        v.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        v.textColor = UIColor.systemIndigo
        return v
    }()
    lazy var logoStack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [logoImageView,logoTextLabel])
        s.axis = .horizontal
        s.spacing = 8
        s.alignment = .fill
        return s
    }()
    var shopName: UITextField = {
       let f = UITextField()
        f.font = UIFont.customFont(.regular, 16)
        let lv = UIView()
        lv.widthAnchor.constraint(equalToConstant: 10).isActive = true
        f.leftView = lv
        f.placeholder = "Enter shop name"
        f.leftViewMode = .always
        f.layer.borderColor = UIColor.lightGray.cgColor
        f.layer.borderWidth = 1
        f.layer.cornerRadius = 12
        return f
    }()
    private var emailTF: UITextField = {
        let f = UITextField()
        f.font = UIFont.customFont(.regular, 16)
        let lv = UIView()
        lv.widthAnchor.constraint(equalToConstant: 10).isActive = true
        f.leftView = lv
        f.placeholder = "Enter email"
        f.leftViewMode = .always
        f.layer.borderColor = UIColor.lightGray.cgColor
        f.layer.borderWidth = 1
        f.layer.cornerRadius = 12
        return f
    }()
    private var passwordTF: UITextField = {
        let f = UITextField()
        f.font = UIFont.customFont(.regular, 16)
        f.isSecureTextEntry = true
        f.placeholder = "Enter password"
        let lv = UIView()
        lv.widthAnchor.constraint(equalToConstant: 10).isActive = true
        f.leftView = lv
        f.leftViewMode = .always
        
        // Right eye button
        let toggleButton = UIButton(type: .custom)
        toggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        toggleButton.tintColor = .gray
        toggleButton.frame = CGRect(x: 0, y: 0, width: 20, height: 16)
        toggleButton.addTarget(nil, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        f.rightView = toggleButton
        f.rightViewMode = .always

        f.layer.borderColor = UIColor.lightGray.cgColor
        f.layer.borderWidth = 1
        f.layer.cornerRadius = 12
        
        return f
    }()
    private var confirmPasswordTF: UITextField = {
        let f = UITextField()
        f.font = UIFont.customFont(.regular, 16)
        f.isSecureTextEntry = true
        f.placeholder = "Confirm password"
        let lv = UIView()
        lv.widthAnchor.constraint(equalToConstant: 10).isActive = true
        f.leftView = lv
        f.leftViewMode = .always
        
        // Right eye button
        let toggleButton = UIButton(type: .custom)
        toggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        toggleButton.tintColor = .gray
        toggleButton.frame = CGRect(x: 0, y: 0, width: 20, height: 16)
        toggleButton.addTarget(nil, action: #selector(toggleConfirmPasswordVisibility), for: .touchUpInside)
        
        f.rightView = toggleButton
        f.rightViewMode = .always

        f.layer.borderColor = UIColor.lightGray.cgColor
        f.layer.borderWidth = 1
        f.layer.cornerRadius = 12
        
        return f
    }()
    private var confirmBtn: UIButton = {
       let b = UIButton()
        b.setTitle("Confirm", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .systemBlue
        b.titleLabel?.font = UIFont.customFont(.bold, 16)
        b.layer.cornerRadius = 12
        return b
    }()
    lazy var stackV: UIStackView = {
        let s = UIStackView(arrangedSubviews: [shopName,emailTF,passwordTF,confirmPasswordTF,confirmBtn])
        s.axis = .vertical
        s.spacing = 16
        s.alignment = .fill
        s.distribution = .fillEqually
        return s
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        apparenceSettings()
    }
    
    func apparenceSettings() {
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(logoStack)
        view.addSubview(stackV)
        confirmBtn.addTarget(self, action: #selector(confirmBtnTapped), for: .touchUpInside)
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        logoStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalTo(view.snp_centerXWithinMargins)
        }
        stackV.snp.makeConstraints { make in
            make.top.equalTo(logoStack.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(24)
        }
        confirmBtn.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        passwordTF.isSecureTextEntry.toggle()
        let imageName = passwordTF.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func toggleConfirmPasswordVisibility(_ sender: UIButton) {
        confirmPasswordTF.isSecureTextEntry.toggle()
        let imageName = confirmPasswordTF.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc func confirmBtnTapped() {
        
        guard let shopName = shopName.text else {return showInfoAlert(title: "Ma'lumotlar to'liq kiritilmadi", message: "Iltimos Do'kon nomini kiriting")}
        guard let email = emailTF.text else {return showInfoAlert(title: "Ma'lumotlar to'liq kiritilmadi", message: "Iltimos e-mailni kiriting")}
        guard let password = passwordTF.text else {return showInfoAlert(title: "Ma'lumotlar to'liq kiritilmadi", message: "Iltimos parolni kiriting")}
        guard let confirmPassword = confirmPasswordTF.text else {return showInfoAlert(title: "Ma'lumotlar to'liq kiritilmagan", message: "Iltimos parolni qayta kiriting")}
        if email.hasSuffix("@gmail.com") == false {
            showInfoAlert(title: "Email notog'ri kiritildi", message: "Iltimos emailni to'g'ri formatda kiriting")
        }else if password != confirmPassword {
            showInfoAlert(title: "Parol notog'ri kiritildi", message: "Kiritilgan parollar bir xil emas")
        }else {
            showLoader()
            FirebaseManager.shared.register(email: email, password: password, shopName: shopName) { result in
                self.hideLoader()
                switch result {
                case .success(let user):
                    print("User token: \( String(describing: user.refreshToken))")
                    if let window = UIApplication.shared.windows.first {
                        cache.set(true, forKey: "isTabbar")
                           window.rootViewController = Tabbar()
                           window.makeKeyAndVisible()
                       }
                case .failure(let error):
                    self.showInfoAlert(title: error.localizedDescription, message: error.localizedDescription.debugDescription)
                }
                
                
            }
        }
        
    }
    
    
    
}
