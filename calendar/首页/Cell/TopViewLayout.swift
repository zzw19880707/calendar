//
//  TopViewCellLineLayout.swift
//  calendar
//
//  Created by cnsyl066 on 15/11/9.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit

class TopViewLayout: UICollectionViewFlowLayout {

    
    override init() {
        super.init()
        self.initialization()
    
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialization()
    }
    
    func initialization() {
        
        let width =  UIScreen.mainScreen().bounds.width / 3
        self.itemSize = CGSize(width: width , height: width * 4 / 3 )
        scrollDirection = .Horizontal
//        两行cell最小间距
        minimumLineSpacing = 50
        minimumInteritemSpacing = 50
    }
    
    
//   step:1 准备布局
    override func prepareLayout() {
        super.prepareLayout()
    }
//   step:2 计算contentsize，显然这一步得在prepare之后进行
//    override func collectionViewContentSize() -> CGSize {
//        return (self.collectionView?.bounds.size)!
//    }
//   step:3 返回在可见区域的view的layoutAttribute信息
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let array = super.layoutAttributesForElementsInRect(rect)
        let visibleRect = CGRect(origin: (self.collectionView?.contentOffset)!, size: (self.collectionView?.bounds.size)!)

        if let arr = array {
            
            for attribute in arr{
//                cell是否在当前可见区域
                if CGRectIntersectsRect(attribute.frame, rect) {
                    let distance = CGRectGetMidX(visibleRect) - attribute.center.x
                    let normalizedDistance = distance / 200
                    if abs(distance) < 200 {
                        let zoom = 1 + 0.3 * (1 - abs(normalizedDistance));
                        attribute.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                        attribute.zIndex = 1
                    }
                }
            }
        }
        return array
    }
    
//   计算滚动视图停止的位置
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat.max
        let horizontalCenter = proposedContentOffset.x + (CGRectGetWidth((self.collectionView?.bounds)!)/2.0)
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: (self.collectionView?.bounds.size.width)!, height: (self.collectionView?.bounds.size.height)!)
        let array = super.layoutAttributesForElementsInRect(targetRect)
        if let arr = array {
            
            for attribute in arr{
                let itemHorizontalCenter = attribute.center.x
                if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {
                    offsetAdjustment = itemHorizontalCenter - horizontalCenter
                }
            }
        }
        return CGPoint(x: (proposedContentOffset.x + offsetAdjustment), y: proposedContentOffset.y)
    }
    
//当边界更改时是否更新布局
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    //通知布局，collection view里有元素即将改变，这里可以收集改变的元素indexPath和action类型。
//    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
//        super.prepareForCollectionViewUpdates(updateItems)
//    }
    //当一个元素被插入collection view时，返回它的初始布局，这里可以加入一些动画效果。
//    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//    }
}
