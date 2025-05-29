import UIKit

class AddProductVC: UIViewController {
    private var backV: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 12
        v.clipsToBounds = true
        return v
    }()
    private var qrBtn: UIButton = {
        let b = UIButton()
       b.setBackgroundImage(UIImage(systemName: "barcode.viewfinder"), for: .normal)
       b.tintColor = .gray
        return b
    }()
    private var productNameTF: UITextField = {
        let f = UITextField()
        f.font = UIFont.customFont(.regular, 16)
        let lv = UIView()
        lv.widthAnchor.constraint(equalToConstant: 10).isActive = true
        f.leftView = lv
        f.placeholder = "Mahsulot nomi"
        f.leftViewMode = .always
        f.layer.borderColor = UIColor.lightGray.cgColor
        f.layer.borderWidth = 1
        f.layer.cornerRadius = 12
        f.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        return f
    }()
    private var purchasePTF: UITextField = {
        let f = UITextField()
        f.font = UIFont.customFont(.regular, 16)
        let lv = UIView()
        lv.widthAnchor.constraint(equalToConstant: 10).isActive = true
        f.leftView = lv
        f.placeholder = "Sotib olish narxi"
        f.leftViewMode = .always
        f.layer.borderColor = UIColor.lightGray.cgColor
        f.keyboardType = .numberPad
        f.layer.borderWidth = 1
        f.layer.cornerRadius = 12
        return f
    }()
    private var soldPTF: UITextField = {
        let f = UITextField()
        f.font = UIFont.customFont(.regular, 16)
        let lv = UIView()
        lv.widthAnchor.constraint(equalToConstant: 10).isActive = true
        f.leftView = lv
        f.placeholder = "Sotish narxi"
        f.leftViewMode = .always
        f.layer.borderColor = UIColor.lightGray.cgColor
        f.keyboardType = .numberPad
        f.layer.borderWidth = 1
        f.layer.cornerRadius = 12
        return f
    }()
     var categoryTF: UITextField = {
        let f = UITextField()
        f.font = UIFont.customFont(.regular, 16)
        let lv = UIView()
        lv.widthAnchor.constraint(equalToConstant: 10).isActive = true
        f.leftView = lv
        f.placeholder = "Kategoriya"
        f.leftViewMode = .always
        f.layer.borderColor = UIColor.lightGray.cgColor
        f.layer.borderWidth = 1
        f.layer.cornerRadius = 12
        return f
    }()
    private var totalProductTF: UITextField = {
        let f = UITextField()
        f.font = UIFont.customFont(.regular, 16)
        let lv = UIView()
        lv.widthAnchor.constraint(equalToConstant: 10).isActive = true
        f.leftView = lv
        f.placeholder = "Jami mahsulot"
        f.leftViewMode = .always
        f.layer.borderColor = UIColor.lightGray.cgColor
        f.keyboardType = .numberPad
        f.layer.borderWidth = 1
        f.layer.cornerRadius = 12
        return f
    }()
    private var productUnitTF: PickerTextField = {
        let p = PickerTextField()
        p.textAlignment = .center
        p.font = UIFont.customFont(.regular, 16)
        p.items = ProductUnit.allCases.map(\.rawValue)
        p.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        p.layer.borderColor = UIColor.lightGray.cgColor
        p.layer.borderWidth = 1
        p.layer.cornerRadius = 12
        return p
    }()
    private var expiryDateTF: UITextField = {
        let f = UITextField()
        f.font = UIFont.customFont(.regular, 16)
        let lv = UIView()
        lv.widthAnchor.constraint(equalToConstant: 10).isActive = true
        f.leftView = lv
        f.placeholder = "Amal qilish muddati"
        f.leftViewMode = .always
        f.layer.borderColor = UIColor.lightGray.cgColor
        f.layer.borderWidth = 1
        f.layer.cornerRadius = 12
        return f
    }()
    lazy var pStackV: UIStackView = {
        let s = UIStackView(arrangedSubviews: [totalProductTF,productUnitTF])
        s.axis = .horizontal
        s.spacing = 16
        s.alignment = .fill
        s.distribution = .fill
        return s
    }()
    lazy var stackV: UIStackView = {
        let s = UIStackView(arrangedSubviews: [productNameTF,purchasePTF,soldPTF,categoryTF,pStackV,expiryDateTF])
        s.axis = .vertical
        s.spacing = 16
        s.alignment = .fill
        s.distribution = .fillEqually
        return s
    }()
    let pickerView = UIPickerView()
    let datePicker = UIDatePicker()
    var barcode: String?
    var isEdit: Bool = false
    var product: ProductCD?
    override func viewDidLoad() {
        super.viewDidLoad()
        apperenceSettings()
        setUI()
    }
    
    func apperenceSettings(){
        title = "Yangi mahsulot qo'shish"
        self.navigationItem.backButtonTitle = ""
        view.backgroundColor = #colorLiteral(red: 0.1214147285, green: 0.2226163745, blue: 0.3583123684, alpha: 1)
        view.addSubview(backV)
        backV.addSubview(qrBtn)
        backV.addSubview(stackV)
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTF.inputView = pickerView
        categoryTF.delegate = self
        qrBtn.addTarget(self, action: #selector(qrBtnTapped), for: .touchUpInside)
        let saveBtn = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItem = saveBtn
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGesTapped))
        view.addGestureRecognizer(tapGes)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        categoryTF.inputAccessoryView = toolbar
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        expiryDateTF.inputView = datePicker
        let toolbar2 = UIToolbar()
        toolbar2.sizeToFit()
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressedDate))
        toolbar2.setItems([doneButton2], animated: true)
        expiryDateTF.inputAccessoryView = toolbar2
        backV.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalTo(0)
        }
        qrBtn.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.top.equalTo(24)
            make.centerX.equalTo(view.snp_centerXWithinMargins)
        }
        stackV.snp.makeConstraints { make in
            make.top.equalTo(qrBtn.snp_bottomMargin).offset(16)
            make.left.right.equalToSuperview().inset(24)
        }
    }
    
    func setUI() {
        if isEdit {
            qrBtn.setTitle(product?.barcode ?? "", for: .normal)
            qrBtn.setBackgroundImage(UIImage(named: ""), for: .normal)
            qrBtn.isEnabled = false
            productNameTF.text = product?.name
            barcode = product?.barcode
            purchasePTF.text = String(describing: product?.purchasePrice)
            soldPTF.text = String(describing: product?.salePrice)
            categoryTF.text = product?.category
            totalProductTF.text = String(describing: product?.totalProduct)
            productUnitTF.text = product?.unitType
            expiryDateTF.text = Formatter.shared.dateToString(product?.validityPeriod ?? Date())
        }
    }
    
    @objc func donePressed() {
        categoryTF.resignFirstResponder()
    }
    @objc func donePressedDate() {
        
           expiryDateTF.text = Formatter.shared.dateToString(datePicker.date)
           expiryDateTF.resignFirstResponder()
       }
    @objc func tapGesTapped() {
        view.endEditing(true)
    }
    @objc func saveTapped()  {
        
        guard let name = productNameTF.text, !name.isEmpty else {
            showAlert(message: "Mahsulot nomini kiriting.")
            return
        }
        
        guard let purchasePriceText = purchasePTF.text, let purchasePrice = Double(purchasePriceText), purchasePrice > 0 else {
            showAlert(message: "Sotib olish narxini to'g'ri kiriting.")
            return
        }
        
        guard let salePriceText = soldPTF.text, let salePrice = Double(salePriceText), salePrice > 0 else {
            showAlert(message: "Sotish narxini to'g'ri kiriting.")
            return
        }
        guard let category = categoryTF.text, !category.isEmpty else {
            showAlert(message: "Category maydonini to'ldiring.")
            return
        }
        
        guard let totalProductText = totalProductTF.text, let totalProduct = Int64(totalProductText), totalProduct >= 0 else {
            showAlert(message: "Miqdor maydonini to'ldiring yoki 0 dan katta qiymat kiriting.")
            return
        }
        
        guard let unitType = productUnitTF.text, !unitType.isEmpty else {
            showAlert(message: "O'lchov birligini kiriting.")
            return
        }
        
        guard let expiryText = expiryDateTF.text, let validityPeriod = Formatter.shared.stringToDate(expiryText) else {
            showAlert(message: "Amal qilish muddatini to'g'ri tanlang.")
            return
        }
        
        if isEdit {
            CoreDataManager.shared.updateProduct(product!, category: category, barcode: barcode ?? "", name: name, purchasePrice: purchasePrice, salePrice: salePrice, totalProduct: totalProduct, unitType: unitType, validityPeriod: validityPeriod)
            FirebaseManager.shared.updateProduct(productId: (product?.barcode)!, barcode: barcode ?? "", category: category, name: name, purchasePrice: purchasePrice, salePrice: salePrice, totalProduct: totalProduct, unitType: unitType, validityPeriod: validityPeriod) { error in
                print("Error = \(String(describing: error?.localizedDescription))")
            }
            
            showAlert("Succes", "Mahsulot muvafaqqiyatli o'zgartirildi") { [self] result in
                guard let result = result else { return showAlert(message: "Alertdan nil qaytdi") }
                if result {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else {
            var productID = UUID().uuidString
            
            CoreDataManager.shared.addProduct(barcode: barcode ?? productID, category: category, name: name, purchasePrice: purchasePrice, salePrice: salePrice, totalProduct: totalProduct, unitType: unitType, validityPeriod: validityPeriod)
            FirebaseManager.shared.addProduct(barcode: barcode ?? productID, category: category, name: name, purchasePrice: purchasePrice, salePrice: salePrice, totalProduct: totalProduct, unitType: unitType, validityPeriod: validityPeriod) { error in
                print("Create error \(String(describing: error?.localizedDescription))")
            }
            showAlert("Succes", "Mahsulot muvafaqqiyatli qo'shildi") { [self] result in
                guard let result = result else { return showAlert(message: "Alertdan nil qaytdi") }
                if result {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        
    }
    @objc func qrBtnTapped() {
        let vc = ReadBarcodeVC()
       
        vc.getCode = { result in
            self.barcode = result
        }
        present(vc, animated: true)
    }
    // Alert ko'rsatish uchun yordamchi funksiya
    func showAlert(message: String, title: String = "Xato") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    
}
