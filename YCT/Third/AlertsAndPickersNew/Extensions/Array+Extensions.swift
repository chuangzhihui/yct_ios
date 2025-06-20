import Foundation

extension Array {
  
  @discardableResult
  mutating func append(_ newArray: Array) -> CountableRange<Int> {
    let range = count..<(count + newArray.count)
    self += newArray
    return range
  }
  
  @discardableResult
  mutating func insert(_ newArray: Array, at index: Int) -> CountableRange<Int> {
    let mIndex = Swift.max(0, index)
    let start = Swift.min(count, mIndex)
    let end = start + newArray.count
    
    let left = self[0..<start]
    let right = self[start..<count]
    self = left + newArray + right
    return start..<end
  }
  
  mutating func remove<T: AnyObject> (_ element: T) {
    let anotherSelf = self
    
    removeAll(keepingCapacity: true)
    
    anotherSelf.each { (index: Int, current: Element) in
      if (current as! T) !== element {
        self.append(current)
      }
    }
  }
  
  func each(_ exe: (Int, Element) -> ()) {
    for (index, item) in enumerated() {
      exe(index, item)
    }
  }
}

extension Array where Element: Equatable {
  
  /// Remove Dublicates
  var unique: [Element] {
    // Thanks to https://github.com/sairamkotha for improving the method
    return self.reduce([]){ $0.contains($1) ? $0 : $0 + [$1] }
  }
  
  /// Check if array contains an array of elements.
  ///
  /// - Parameter elements: array of elements to check.
  /// - Returns: true if array contains all given items.
  func contains(_ elements: [Element]) -> Bool {
    guard !elements.isEmpty else { // elements array is empty
      return false
    }
    var found = true
    for element in elements {
      if !contains(element) {
        found = false
      }
    }
    return found
  }
  
  /// All indexes of specified item.
  ///
  /// - Parameter item: item to check.
  /// - Returns: an array with all indexes of the given item.
  func indexes(of item: Element) -> [Int] {
    var indexes: [Int] = []
    for index in 0..<self.count {
      if self[index] == item {
        indexes.append(index)
      }
    }
    return indexes
  }
  
  /// Remove all instances of an item from array.
  ///
  /// - Parameter item: item to remove.
  mutating func removeAll(_ item: Element) {
    self = self.filter { $0 != item }
  }
  
  /// Creates an array of elements split into groups the length of size.
  /// If array can’t be split evenly, the final chunk will be the remaining elements.
  ///
  /// - parameter array: to chunk
  /// - parameter size: size of each chunk
  /// - returns: array elements chunked
  func chunk(size: Int = 1) -> [[Element]] {
    var result = [[Element]]()
    var chunk = -1
    for (index, elem) in self.enumerated() {
      if index % size == 0 {
        result.append([Element]())
        chunk += 1
      }
      result[chunk].append(elem)
    }
    return result
  }
}

extension Array {
  
  /// Random item from array.
  var randomItem: Element? {
    if self.isEmpty { return nil }
    let index = Int(arc4random_uniform(UInt32(count)))
    return self[index]
  }
  
  /// Shuffled version of array.
  var shuffled: [Element] {
    var arr = self
    for _ in 0..<10 {
      arr.sort { (_,_) in arc4random() < arc4random() }
    }
    return arr
  }
  
  /// Shuffle array.
  mutating func shuffle() {
    // https://gist.github.com/ijoshsmith/5e3c7d8c2099a3fe8dc3
    for _ in 0..<10 {
      sort { (_,_) in arc4random() < arc4random() }
    }
  }
  
  /// Element at the given index if it exists.
  ///
  /// - Parameter index: index of element.
  /// - Returns: optional element (if exists).
  func item(at index: Int) -> Element? {
    guard index >= 0 && index < count else { return nil }
    return self[index]
  }
}

extension Array {
    public func get(_ index: Int) -> Element? {
        if index < self.count {
            return self[index]
        }
        return nil
    }
    public func filteredByType<T> (_ : T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}

extension Array where Element: Equatable {

    static func -=(lhs: inout Array, rhs: Array) {

        rhs.forEach {
            if let indexOfhit = lhs.firstIndex(of: $0) {
                lhs.remove(at: indexOfhit)
            }
        }
    }

    static func -(lhs: Array, rhs: Array) -> Array {

        return lhs.filter { return !rhs.contains($0) }
    }
}

extension Collection {
    public func count(where test: (Element) throws -> Bool) rethrows -> Int {
        return try self.filter(test).count
    }
}
