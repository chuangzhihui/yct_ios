import UIKit

extension NSAttributedString {
  
  // MARK: - Makes a copy of the existing attributes for NSAttributedString and sets color for specific string(s)
  func makeStringWithColor(forString stringArray: [String], withColor color: UIColor) -> NSMutableAttributedString {
    
    // Existing attributes
    let attributedString = NSMutableAttributedString(attributedString: self)
    
    // Iterate through strings
    for specifiedString in stringArray {
      
      // Whole range (for regex)
      let range = NSMakeRange(0, self.string.count)
      
      // Find several occurences
      do {
        let regex = try NSRegularExpression(pattern: specifiedString, options: .caseInsensitive)
        
        // Enumerate matches
        regex.enumerateMatches(in: self.string, options: .reportCompletion, range: range, using: { (result, _, _) in
          
          // Substring range
          if let subStringRange = result?.range(at: 0) {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: subStringRange)
          }
        })
      }
      
      catch {
        print(error)
      }
    }
    
    return attributedString
  }
  
  // MARK: - Makes a copy of existing attributes for NSAttributedString and returns a new NSMutableString with a new text / string.
  func makeStringWith(text newString: String) -> NSMutableAttributedString {
    
    // Keep existing attributes
    let attributedString = NSMutableAttributedString(attributedString: self)
    
    // Update string, keep attributes
    attributedString.mutableString.setString(newString)
    
    return attributedString
  }
}
