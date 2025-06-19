import UIKit

class CustomCircularCollectionViewLayout: UICollectionViewLayout {

  var itemSize = CGSize(width: 200, height: 150)
  var attributesList = [UICollectionViewLayoutAttributes]()


  override func prepare() {
    super.prepare()

    let itemNo = collectionView?.numberOfItems(inSection: 0) ?? 0
    let length = (collectionView!.frame.width - 16)/3
    let height = length * 66 / 107

    itemSize = CGSize(width: length, height: height)

    attributesList = (0..<itemNo).map { (i) -> UICollectionViewLayoutAttributes in
      let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))

      attributes.size = self.itemSize

      var x = CGFloat(i%3)*(itemSize.width+4) + 4
      var y = CGFloat(i/3)*(itemSize.height+4) + 4

      if i > 2 {
        y += (itemSize.height+4)
        attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
      } else if i == 0 {
        attributes.frame = CGRect(x: x, y: y, width: itemSize.width*2+4, height: itemSize.height*2+4)
      } else {
        x = itemSize.width*2 + 12
        if i == 2 {
          y += itemSize.height + 4
        }
        attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
      }

      return attributes
    }
  }

  override var collectionViewContentSize : CGSize {

    return CGSize(width: collectionView!.bounds.width, height: (itemSize.height + 4)*CGFloat(ceil(Double(collectionView!.numberOfItems(inSection: 0))/3))+(itemSize.height + 8))

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
