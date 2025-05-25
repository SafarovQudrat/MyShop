import UIKit

enum Items: String,CaseIterable {
    case qoldiq = "Qolgan mahsulotlar"
    case tarix = "Tarix"
    case qarz = "Qarzlar"
    case hisobot = "Hisobot"
    case til = "Til"
    case share = "Ulashish"
    case aboutus = "Biz haqimizda"
    case logOut = "Chiqish"
}

enum Category: String,CaseIterable {
    case oziqovqat = "Oziq-ovqat"
    case Ichimliklar = "Ichimliklar"
    case xojalikbuyumlari = "Xo'jalik buyumlari"
    case kosmetika = "Kosmetika"
    case oquvqurollari = "O'quv qurollari"
    case elektronika = "Elektronika"
    case xizmatlar = "Xizmatlar"
    case boshqa = "Boshqa"
}

enum ProductUnit:String,CaseIterable {
    case dona = "dona"
    case kg = "kg"
    case gramm = "gramm"
    case litr = "litr"
}

struct Product {
    var product:ProductCD
    var count: Int
}
struct EachSale {
    var saleProducts:[Product]
    var foyda:Double
    var summ:Double
}
