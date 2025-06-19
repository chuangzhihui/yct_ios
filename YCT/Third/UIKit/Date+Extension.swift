import Foundation

extension Formatter {
  static let iso8601FractionalSeconds: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
  }()
  
  static let iso8601: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    return formatter
  }()

  static let createdDateFormatter: DateFormatter = {
    let formatterString = DateFormatter.dateFormat(fromTemplate: "ddMMyyyy", options: 0, locale: Locale.current)!
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate(formatterString)
    return formatter
  }()

  static let expiryDateFormatter: DateFormatter = {
    let formatterString = DateFormatter.dateFormat(fromTemplate: "ddMMMyyyy", options: 0, locale: Locale.current)!
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate(formatterString)
    return formatter
  }()
}

extension String {
  var toIsoDate: Date? {
    Formatter.iso8601FractionalSeconds.date(from: self)
  }
}

extension Date {
    var toIsoString: String {
        Formatter.iso8601FractionalSeconds.string(from: self)
    }
    
    func formatToString(format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
