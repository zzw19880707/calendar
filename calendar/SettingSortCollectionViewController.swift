//
//  SettingSortCollectionViewController.swift
//  calendar
//
//  Created by cnsyl066 on 15/10/22.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SettingSortCollectionViewController: UICollectionViewController {

    var dataArr = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 60, height: 50)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        collectionView!.collectionViewLayout = layout
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongGesture:")
        collectionView!.addGestureRecognizer(longPressGesture)
        
    }
    
    var moveCell : UIView?
    var selectCell : UICollectionViewCell?
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case UIGestureRecognizerState.Began:
            guard let selectedIndexPath = collectionView!.indexPathForItemAtPoint(gesture.locationInView(self.collectionView))
                else {
                    
                break
            }
            
            let cell = collectionView?.cellForItemAtIndexPath(selectedIndexPath)
            
            moveCell = cell!.snapshotViewAfterScreenUpdates(false)
            moveCell!.frame = collectionView!.convertRect(cell!.frame, toView: view)
            view.addSubview(moveCell!)
            allCellBenginShake()

            collectionView!.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
        case UIGestureRecognizerState.Changed:
            collectionView!.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
        case UIGestureRecognizerState.Ended:
            allCellEndShake(gesture)
            collectionView!.endInteractiveMovement()
        default:
            allCellEndShake(gesture)
            collectionView!.cancelInteractiveMovement()
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
        for cell  in collectionView!.visibleCells() as! [SettingSortCollectionViewCell]{
            cell.layer.addAnimation(shakeAnimation, forKey: "shake")
        }
        moveCell!.layer.addAnimation(shakeAnimation, forKey: "shake")
    }
    func allCellEndShake(gesture: UILongPressGestureRecognizer){
        for cell  in collectionView!.visibleCells() as! [SettingSortCollectionViewCell]{
            cell.layer.removeAnimationForKey("shake")
        }
        moveCell!.layer.removeAnimationForKey("shake")

    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SettingSortCollectionViewCell
        cell.textLabel.text! = dataArr[indexPath.row] as String
        cell.highlighted = true
        cell.backgroundColor = UIColor.yellowColor()
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        dataArr.insert(dataArr.removeAtIndex(sourceIndexPath.row), atIndex: destinationIndexPath.row)
        (parentViewController as! SettingDataViewController).data["type"] = dataArr
    }
    

    

    
}
