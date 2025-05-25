import UIKit

protocol SaleTVCDelegate: AnyObject {
    func didChangeStepperValue(_ cell: SaleTVC, value: Int)
    func didTapDelete(_ cell: SaleTVC)
}

class SaleTVC: UITableViewCell {
    
    weak var delegate: SaleTVCDelegate?

    @IBOutlet weak var nameLbl: UILabel! {
        didSet {
            nameLbl.font = .customFont(.medium, 16)
        }
    }
    @IBOutlet weak var costLbl: UILabel! {
        didSet {
            costLbl.font = .customFont(.regular, 16)
        }
    }
    @IBOutlet weak var sumLbl: UILabel! {
        didSet {
            sumLbl.font = .customFont(.regular, 16)
        }
    }
    @IBOutlet weak var totalCostLbl: UILabel! {
        didSet {
            totalCostLbl.font = .customFont(.regular, 16)
        }
    }

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var deleteBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        deleteBtn.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
    }

    @objc private func stepperValueChanged() {
        delegate?.didChangeStepperValue(self, value: Int(stepper.value))
    }

    @objc private func deleteBtnTapped() {
        delegate?.didTapDelete(self)
    }

    func configureSale(product: ProductCD,count:Int) {
        nameLbl.text = product.name
        costLbl.text = "\(product.salePrice) so'm"
        sumLbl.text = "\(count) dona"
        totalCostLbl.text = "\(product.salePrice * Double(count)) so'm"
        stepper.value = Double(count)
    }
    
    func configureAllProducts(product: ProductCD) {
        stepper.isHidden = true
        deleteBtn.isHidden = true
        nameLbl.text = product.name
        costLbl.text = "\(product.salePrice) so'm"
        sumLbl.text = "\(product.totalProduct) \(product.unitType!)"
    }
    
    func configureDebts(debt:Debts){
        costLbl.text = "\(debt.summ) so'm"
        nameLbl.text = debt.name
        totalCostLbl.text = Formatter.shared.dateToString(debt.date ?? Date())
    }
    
    func configureSaleHistory(sale:[ProductCD],date:Date,summ:Double){
        let allNames = sale.compactMap { $0.name }.joined(separator: ", ")
        nameLbl.text = allNames
        costLbl.text = Formatter.shared.dateToString(date)
        sumLbl.text = "\(summ) so'm"
    }
}
