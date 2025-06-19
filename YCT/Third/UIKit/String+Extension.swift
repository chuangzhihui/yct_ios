import Foundation

extension String {
  func percentEncoded() -> Self {
    let this = self
    return percentEncodeString(string: this)
  }

  func percentEncodeString(string: String) -> Self {
    let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet.init(charactersIn: "-._*"))
    return string
      .addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
  }

  var quoted: String {
    "\"\(self)\""
  }

  static var truncationLimit = 500
  func truncated() -> String {
    return String(prefix(String.truncationLimit))
  }

  func replacingFirstOccurrence(of target: String, with replacement: String) -> String {
    guard let range = self.range(of: target) else { return self }
    return self.replacingCharacters(in: range, with: replacement)
  }

  var addressDirection: String {
    return "https://maps.apple.com/?address=\(self.percentEncoded())"
  }

  func openAddress() {
    guard self.isNotEmpty, let url = URL(string: self.addressDirection) else { return }
    url.open()
  }
}

extension String {
  var isNotEmpty: Bool {
    !self.isEmpty
  }
}

extension String {
  func filter(by filter: [String]) -> String {
    var raw = self
    filter.forEach { char in
      raw = raw.replacingOccurrences(of: char, with: "")
    }
    return raw
  }
}


extension String {
  var link: URL? {
    let range = NSRange(self.startIndex..<self.endIndex, in: self)
    let types: NSTextCheckingResult.CheckingType = [.link]
    let detector = try? NSDataDetector(types: types.rawValue)
    var url: URL?
    detector?.enumerateMatches(in: self,
                              options: [],
                              range: range) { (result, _, _) in
      url = result?.url
    }
    return url
  }

  func openLink() {
    guard let url = self.link else { return }
    url.open()
  }
}


