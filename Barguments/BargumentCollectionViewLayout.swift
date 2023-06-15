import UIKit

class BargumentCollectionViewLayout: UICollectionViewFlowLayout {
    

    override func prepare() {
        super.prepare()

        
        scrollDirection = .horizontal
        itemSize = CGSize(width: collectionView!.bounds.width * 0.75, height: collectionView!.bounds.height * 0.8)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let originalAttributes = super.layoutAttributesForElements(in: rect)
        guard let attributes = originalAttributes else {
            return nil
        }
        
        let collectionViewCenterX = collectionView!.contentOffset.x + collectionView!.bounds.width / 2
        var adjustedAttributes: [UICollectionViewLayoutAttributes] = []

        for attribute in attributes {
            let copyAttribute = attribute.copy() as! UICollectionViewLayoutAttributes
            let distance = abs(collectionViewCenterX - copyAttribute.center.x)
            let scale = 1 - distance / collectionView!.bounds.width
            copyAttribute.transform = CGAffineTransform(scaleX: scale, y: scale)
            adjustedAttributes.append(copyAttribute)
        }

        return adjustedAttributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
            guard let collectionView = collectionView else {
                return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            }

            let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
            
            guard let layoutAttributes = layoutAttributesForElements(in: targetRect) else {
                return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            }

            var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + (collectionView.bounds.width * 0.5)

            for attributes in layoutAttributes {
                let itemHorizontalCenter = attributes.center.x
                if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {
                    offsetAdjustment = itemHorizontalCenter - horizontalCenter
                }
            }

            let nextOffset = proposedContentOffset.x + offsetAdjustment

            // Make sure the proposed offset is not out of bounds
            let maxOffset = collectionView.contentSize.width - collectionView.bounds.width
            return CGPoint(x: min(max(nextOffset, 0), maxOffset), y: proposedContentOffset.y)
        }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

        override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            let attributes = super.layoutAttributesForItem(at: indexPath)
            return attributes?.copy() as? UICollectionViewLayoutAttributes
        }
}
