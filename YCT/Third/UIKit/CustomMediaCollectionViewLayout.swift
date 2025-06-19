import UIKit

class CustomMediaCollectionViewLayout: UICollectionViewLayout {

  var itemSize = CGSize(width: 280, height: 185)
  var attributesList = [UICollectionViewLayoutAttributes]()

  override func prepare() {
    super.prepare()

    let itemNo = collectionView?.numberOfItems(inSection: 0) ?? 0
    let width = (collectionView!.frame.width - 4)/2
    let height = width * 185 / 280

    itemSize = CGSize(width: width, height: height)

    attributesList = (0..<itemNo).map { (i) -> UICollectionViewLayoutAttributes in
      let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))

      attributes.size = self.itemSize

      var x: CGFloat = 0.0
      var y: CGFloat = 0.0

      if i == 0 {
        attributes.frame = CGRect(x: x, y: y, width: itemSize.width * 2 + 4, height: itemSize.height * 2 + 4)
      } else {
        if i % 2 == 0 {
          x = itemSize.width + 4
        } else {
          x = 0
        }

        let smallRow = CGFloat(ceil(Double((i - 1)/2)))
        y = (itemSize.height * 2 + 8) + smallRow * (itemSize.height + 4)
        //print("thong index \(i) smallRow:\(smallRow) x:\(x) y:\(y)")
        attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
      }

      return attributes
    }
  }

  override var collectionViewContentSize : CGSize {
    let numberOfItems = collectionView!.numberOfItems(inSection: 0)
    let smallRow = CGFloat(ceil(Double((numberOfItems)/2)))
    let numRow = smallRow + 2
    let height = (itemSize.height + 4) * numRow 

    //print("thong numberOfItems \(numberOfItems) smallRow:\(smallRow) numRow:\(numRow) height:\(height)")

    return CGSize(
      width: collectionView!.bounds.width,
      height: height
    )
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return attributesList
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if indexPath.row < attributesList.count
    {
      return attributesList[indexPath.row]
    }
    return nil
  }

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}
