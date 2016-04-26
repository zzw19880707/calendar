//
//  SettingSortCollectionView.swift
//  calendar
//
//  Created by cnsyl066 on 16/3/24.
//  Copyright © 2016年 佐筱猪. All rights reserved.
//

import UIKit
private let reuseIdentifier = "Cell"

class SettingSortCollectionView: UICollectionView , UICollectionViewDataSource , UICollectionViewDelegate {
    
    var dataArr : Array<String> {
        get {
            return CalendarData.getType()
        }
        set {
            CalendarData.setDataByType(newValue)
        }
    }
    override func awakeFromNib() {

        self.dataSource = self
        self.delegate = self
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 60, height: 50)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        self.collectionViewLayout = layout
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        self.addGestureRecognizer(longPressGesture)

    }
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case UIGestureRecognizerState.Began:
            guard let selectedIndexPath = self.indexPathForItemAtPoint(gesture.locationInView(self))
                else {
                    
                    break
            }
            
            allCellBenginShake()
            
            self.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
        case UIGestureRecognizerState.Changed:
            self.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
        case UIGestureRecognizerState.Ended:
            allCellEndShake(gesture)
            self.endInteractiveMovement()
        default:
            allCellEndShake(gesture)
            self.cancelInteractiveMovement()
        }
        
        
        
    }
    
    /// MARK: -
    func allCellBenginShake(){
        //            抖动动画
        let shakeAnimation = CAKeyframeAnimation()
        shakeAnimation.keyPath = "transform.rotation.z"
        shakeAnimation.values = [ -0.05 ,0.05]
        shakeAnimation.duration = 0.1
        shakeAnimation.repeatCount =   Float(INT32_MAX)
        for cell  in self.visibleCells() as! [SettingSortCollectionViewCell]{
            cell.layer.addAnimation(shakeAnimation, forKey: "shake")
        }
    }
    func allCellEndShake(gesture: UILongPressGestureRecognizer){
        for cell  in self.visibleCells() as! [SettingSortCollectionViewCell]{
            cell.layer.removeAnimationForKey("shake")
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SettingSortCollectionViewCell
        cell.textLabel.text! = dataArr[indexPath.row] as String
        cell.highlighted = true
        cell.backgroundColor = UIColor.yellowColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        dataArr.insert(dataArr.removeAtIndex(sourceIndexPath.row), atIndex: destinationIndexPath.row)
    }
}
