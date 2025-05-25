import Foundation

class Formatter {
    
    static let shared = Formatter()
    
    private let dateFormatter: DateFormatter
    
    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
    }
    
    func stringToDate(_ string: String, format: String = "yyyy-MM-dd ") -> Date? {
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
    
    func dateToString(_ date: Date, format: String = "yyyy-MM-dd") -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func dayMonthString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "uz_Latn")
        formatter.dateFormat = "d-MMMM"
        return formatter.string(from: date)
    }
    
    // Yangi funksiya: 12-yanvar 2025
    func dayMonthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "uz_Latn")
        formatter.dateFormat = "d-MMMM yyyy"
        return formatter.string(from: date)
    }
}
