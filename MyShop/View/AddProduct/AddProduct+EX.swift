import UIKit

extension AddProductVC: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   

       // MARK: - Picker View Data Source & Delegate
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return Category.allCases.count
       }

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return Category.allCases[row].rawValue
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           categoryTF.text = Category.allCases[row].rawValue
       }
    
    
}
