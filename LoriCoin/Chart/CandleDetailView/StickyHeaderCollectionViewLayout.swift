//
//  StickyHeaderCollectionViewLayout.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/4/21.
//

import Foundation
import UIKit

class StickyHeaderLayout: UICollectionViewFlowLayout {

    var maxYToStick: CGFloat = 0

    private let headerHeight: CGFloat = 192
    private let headerMaxYOffset: CGFloat = 0

    override init() {
        super.init()
        self.sectionFootersPinToVisibleBounds = true
        self.sectionHeadersPinToVisibleBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sectionFootersPinToVisibleBounds = true
        self.sectionHeadersPinToVisibleBounds = true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }

        for attribute in attributes {
            adjustAttributesIfNeeded(attribute)
        }
        return attributes
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
        adjustAttributesIfNeeded(attributes)
        return attributes
    }

    func adjustAttributesIfNeeded(_ attributes: UICollectionViewLayoutAttributes) {
        switch attributes.representedElementKind {
        case UICollectionView.elementKindSectionHeader?:
            adjustHeaderAttributesIfNeeded(attributes)
        case UICollectionView.elementKindSectionFooter?:
            adjustFooterAttributesIfNeeded(attributes)
        default:
            break
        }
    }

    private func adjustHeaderAttributesIfNeeded(_ attributes: UICollectionViewLayoutAttributes) {
        guard let collectionView = collectionView else { return }
        guard attributes.indexPath.section == 0, collectionView.numberOfItems(inSection: 0) > 0 else { return }

        let contentOffset = collectionView.contentOffset.y
        if collectionView.contentOffset.y > -collectionView.contentInset.top {
            let frameFirst = layoutAttributesForItem(at: IndexPath(row: 0, section: 0))?.frame ?? .zero
            if contentOffset > -headerMaxYOffset {
                attributes.frame.origin.y = contentOffset + headerMaxYOffset
            } else {
                attributes.frame.origin.y = frameFirst.minY - headerHeight
            }
        }
    }

    private func adjustFooterAttributesIfNeeded(_ attributes: UICollectionViewLayoutAttributes) {
        guard let collectionView = collectionView else { return }
        guard attributes.indexPath.section == collectionView.numberOfSections - 1 else { return }

        if collectionView.contentOffset.y + collectionView.bounds.size.height > collectionView.contentSize.height {
            attributes.frame.origin.y = collectionView.contentOffset.y + collectionView.bounds.size.height - attributes.frame.size.height
        }
    }
}
