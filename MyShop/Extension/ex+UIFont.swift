import UIKit

enum CustomFont {
    
    case light
    case regular
    case medium
    case semibold
    case bold
}

extension UIFont {
    static func customFont(_ font: CustomFont,_ size: CGFloat) -> UIFont {
    
        switch font {
        case .light:
            return UIFont(name: "Poppins-Light", size: size) ?? UIFont()
        case .regular:
            return UIFont(name: "Poppins-Regular", size: size) ?? UIFont()
        case .medium:
            return UIFont(name: "Poppins-Medium", size: size) ?? UIFont()
        case .semibold:
            return UIFont(name: "Poppins-SemiBold", size: size) ?? UIFont()
        case .bold:
            return UIFont(name: "Poppins-Bold", size: size) ?? UIFont()
        }}
}
