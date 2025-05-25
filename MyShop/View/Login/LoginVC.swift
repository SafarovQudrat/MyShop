import UIKit
import SnapKit
class LoginVC: UIViewController {
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
    
    private var emailTF: UITextField = {
        let f = UITextField()
        f.font = UIFont.customFont(.regular, 16)
        let lv = UIView()
        lv.widthAnchor.constraint(equalToConstant: 10).isActive = true
        f.keyboardType = .emailAddress
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
    private var confirmBtn: UIButton = {
       let b = UIButton()
        b.setTitle("Login", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .systemBlue
        b.titleLabel?.font = UIFont.customFont(.bold, 16)
        b.layer.cornerRadius = 12
        return b
    }()
    private var txtLbl: UILabel = {
        let l = UILabel()
        l.textColor = .systemGray
        l.textAlignment = .center
        l.font = UIFont.customFont(.regular, 14)
        l.text = "Don't have an account?"
        return l
    }()
    private var registerBtn: UIButton = {
        let b = UIButton()
        b.setTitle("Register", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.titleLabel?.font = UIFont.customFont(.regular, 14)
        return b
    }()
    lazy var registerStack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [txtLbl,registerBtn])
        s.axis = .horizontal
        s.spacing = 4
        s.alignment = .center
        s.distribution = .fillProportionally
        return s
    }()
    
    lazy var stackV: UIStackView = {
        let s = UIStackView(arrangedSubviews: [emailTF,passwordTF,confirmBtn])
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
        view.addSubview(registerStack)
        confirmBtn.addTarget(self, action: #selector(confirmBtnTapped), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(registerBtnTapped), for: .touchUpInside)
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        logoStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalTo(view.snp_centerXWithinMargins)
        }
        stackV.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp_centerXWithinMargins)
            make.centerY.equalTo(view.snp_centerYWithinMargins).offset(-70)
            make.left.right.equalToSuperview().inset(24)
        }
        confirmBtn.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        registerStack.snp.makeConstraints { make in
            make.top.equalTo(stackV.snp_bottomMargin).offset(12)
            make.centerX.equalTo(view.snp_centerXWithinMargins)
        }
        
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        passwordTF.isSecureTextEntry.toggle()
        let imageName = passwordTF.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc func confirmBtnTapped() {
        guard let email = emailTF.text else {return showInfoAlert(title: "Ma'lumotlar to'liq kiritilmadi", message: "Iltimos e-mailni kiriting")}
        guard let password = passwordTF.text else {return showInfoAlert(title: "Ma'lumotlar to'liq kiritilmadi", message: "Iltimos parolni kiriting")}
        showLoader()
        FirebaseManager.shared.login(email: email, password: password) { result in
            self.hideLoader()
            switch result {
            case .success(let user):
                print("User token: \( String(describing: user.refreshToken))")
                if let window = UIApplication.shared.windows.first {
                    cache.set(true, forKey: "isTabbar")
                       window.rootViewController = Tabbar()
                       window.makeKeyAndVisible()
                   }
            case .failure(_):
                self.showInfoAlert(title: "", message: "Kiritilgan ma'lumotlar notog'ri yoki bunday xisob egasi mavjud emas")
            }
        }
    }
    
    @objc func registerBtnTapped(){
        self.navigationItem.backButtonTitle = ""
        let vc = RegisterVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
