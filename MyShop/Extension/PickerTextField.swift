import UIKit

class PickerTextField: UITextField {

    // MARK: - Public properties
    var items: [String] = [] {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    var selectedItem: String? {
        guard items.indices.contains(selectedRow) else { return nil }
        return items[selectedRow]
    }
    var onItemSelected: ((String) -> Void)?

    // MARK: - Private properties
    private let pickerView = UIPickerView()
    private var selectedRow: Int = 0

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        inputView = pickerView

        pickerView.delegate = self
        pickerView.dataSource = self

        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        toolbar.setItems([doneButton], animated: true)
        inputAccessoryView = toolbar
    }

    @objc private func doneTapped() {
        guard items.indices.contains(selectedRow) else { return }
        let item = items[selectedRow]
        self.text = item
        onItemSelected?(item)
        resignFirstResponder()
    }
}

// MARK: - UIPickerViewDelegate & DataSource
extension PickerTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        items.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        items[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
}
