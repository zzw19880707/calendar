//
//  CalendarListViewController.swift
//  calendar
//
//  Created by cnsyl066 on 16/4/26.
//  Copyright © 2016年 佐筱猪. All rights reserved.
//

import UIKit
public let listViewHeight : CGFloat  = UIScreen.mainScreen().bounds.size.width * 300 / 375

class CalendarListViewController: BaseViewController {
    //循环次数
    let CYCLE_COUNT = 50

    ///当前屏幕高

    ///所有的key
    var allKeyArr = CalendarData.getAllKeys()

    ///用于移动的View
    var moveView : UIView?
    /// 移动时的背景视图，可以做修改和删除操作
    var moveBgView : UIView?
    ///移动时选中的cell对应的索引    //或者点击时
    var selectCellIndexPath : NSIndexPath?
    
    var beginTouchPoint : CGPoint?
    var currentType = [String]()
    @IBOutlet weak var collection: UICollectionView!
    
    /// 用于页面关闭时，动画用
    var selectCellFrame = CGRectZero
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadData()

        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        collection.addGestureRecognizer(longGesture)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let _ = selectCellIndexPath  {
            return
        }
        let indexPath = NSIndexPath(forRow: self.allKeyArr!.count * self.CYCLE_COUNT , inSection: 0)
        self.collection!.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)

    }
}

    // MARK: - Action
extension CalendarListViewController{
    //    移动
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case UIGestureRecognizerState.Began:
            if let selectedIndexPath = collection.indexPathForItemAtPoint(gesture.locationInView(collection)) {
                if let cell = collection.cellForItemAtIndexPath(selectedIndexPath){
                    cell.hidden = true

                    selectCellIndexPath = selectedIndexPath
                    moveBgView = UIView()
                    moveBgView?.frame = cell.frame
                    moveBgView?.backgroundColor = UIColor.redColor()
                    collection.addSubview(moveBgView!)
                    let editLB = UILabel()
                    editLB.frame = CGRect(x: 0, y: moveBgView!.frame.size.height - 30 , width: moveBgView!.frame.size.width , height: 30 )
                    editLB.textColor = UIColor.whiteColor()
                    editLB.font = UIFont.boldSystemFontOfSize(25)
                    editLB.text = "编辑"
                    editLB.textAlignment = .Center
                    moveBgView?.addSubview(editLB)
                    
                    let editTipLB = ProgressLabel(frame: CGRect(x: 0, y: editLB.frame.origin.y - 20 , width: editLB.frame.size.width , height: 20 ) )
                    editTipLB.font = UIFont.systemFontOfSize(15)
                    editTipLB.text = "松开手后进入编辑"
                    editTipLB.textColor = UIColor.redColor()
                    editTipLB.tag = 100
                    moveBgView?.addSubview(editTipLB)
                    
                    
                    //如果key是 ud_data 则没有删除
                    let key = allKeyArr![selectedIndexPath.row % allKeyArr!.count]
                    
                    if key != UD_DATA  {
                        let deleteLB = UILabel()
                        deleteLB.frame = CGRect(x: 0, y: 0 , width: moveBgView!.frame.size.width , height: 30 )
                        deleteLB.textColor = UIColor .whiteColor()
                        deleteLB.font = UIFont.boldSystemFontOfSize(25)
                        deleteLB.text = "删除"
                        deleteLB.textAlignment = .Center
                        moveBgView?.addSubview(deleteLB)
                        
                        let deleteTipLB = ProgressLabel(frame: CGRect(x: 0, y: 30 , width: editLB.frame.size.width , height: 20 ) )
                        deleteTipLB.font = UIFont.systemFontOfSize(15)
                        deleteTipLB.text = "松开手后删除"
                        deleteTipLB.textColor = UIColor.redColor()
                        deleteTipLB.tag = 101
                        moveBgView?.addSubview(deleteTipLB)
                    }
                    
                    
                    moveView = UIView()
                    moveView?.frame = moveBgView!.bounds
                    moveView?.backgroundColor = UIColor.lightGrayColor()
                    moveBgView?.addSubview(moveView!)
                    
                    
                    let label = (cell as! CalendarListCollectionViewCell).nameLabel
                    let nameLb = UILabel()
                    nameLb.frame = moveView!.bounds
                    nameLb.text = label.text
                    nameLb.textColor = UIColor.whiteColor()
                    nameLb.font = UIFont.boldSystemFontOfSize(30)
                    nameLb.textAlignment = .Center
                    nameLb.alpha = 0
                    moveView?.addSubview(nameLb)
                    
                    UIView.animateWithDuration(0.75, animations: { 
                        nameLb.alpha = 1
                    })
                    
                    beginTouchPoint = gesture.locationInView(moveBgView)

                }
            }
            
            
        case UIGestureRecognizerState.Changed:
            let point = gesture.locationInView(moveBgView!)
            let x : CGFloat = 0
            var y =  point.y -  beginTouchPoint!.y
            //如果key是 ud_data 则没有删除
            let key = allKeyArr![selectCellIndexPath!.row % allKeyArr!.count]
            
            
            if fabs(y) < 80 {
                
            }else {
                
                if y > 0 {
                    y = 80
                }else if y < 0  {
                    y = -80
                }
            }
            if UD_DATA == key && y > 0  {
                y = 0
            }
            moveView!.frame.origin = CGPoint(x: x , y: y )
            if  key != UD_DATA && y > 0  {//删除
                let editTipLB = moveBgView?.viewWithTag(101) as! ProgressLabel
                editTipLB.progress =  min ( 1.0, max (0 ,( y - 50.0) / 20.0) )
                
            }else  if  y < 0  { // 编辑
                let editTipLB = moveBgView?.viewWithTag(100) as! ProgressLabel
                editTipLB.progress =  min ( 1.0, max (0 ,( -y - 50.0) / 20.0) )
                
            }
            
        case UIGestureRecognizerState.Ended:
            let key = allKeyArr![selectCellIndexPath!.row % allKeyArr!.count]
            removeMoveView()

            if moveView!.frame.origin.y < -70 {
                editAction(key)
            }else if moveView!.frame.origin.y > 70 {
                deleteAction(key)
            }
        default:
            removeMoveView()
        }
        
        
        
    }
    ///编辑
    func editAction(key : String) -> Void {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CalendarAddViewController") as! UINavigationController
        let v = vc.viewControllers[0] as! CalendarAddViewController
        //跟key 有顺序，先设置是否是编辑，在设置key
        v.isAddVC = false
        v.key = key
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .Custom

        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func deleteAction(key : String) -> Void {
        CalendarData.removeDataByKey(key)
        
        self.reloadData()
    }
    
    
    
    func reloadData() -> Void {
        allKeyArr = CalendarData.getAllKeys()
        currentType =  [String]()
        for key in allKeyArr! {
            let type = CalendarData.getTypeByKey(key)
            let date = CalendarData.getDateByKey(key)
            
            let index = NSDate().getTodayTypebyCurrentDate(date, num: type.count)
            currentType.append(type[index])
        }
        collection.reloadData()
        self.view.setNeedsLayout()

    }
    func removeMoveView() -> Void {
        if let cell = collection.cellForItemAtIndexPath(selectCellIndexPath!){
            cell.hidden = false
        }
        self.selectCellIndexPath = nil

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)( 0.5 * Double( NSEC_PER_SEC) )), dispatch_get_main_queue()){
            self.moveBgView?.removeFromSuperview()
            self.moveView?.removeFromSuperview()
            self.moveView = nil
            self.moveBgView = nil
        }
    }
}

extension CalendarListViewController : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return allKeyArr!.count * 2 * CYCLE_COUNT
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CalendarListCollectionViewCell
        
        let index = indexPath.row % allKeyArr!.count
        var name = allKeyArr![index]
        if name == UD_DATA {
            name = "我"
            cell.nameLabel.textColor = UIColor.redColor()
        }else{
            cell.nameLabel.textColor = UIColor.blackColor()
        }
        
        cell.setText( name , data: currentType[index])
        
        if traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: cell)
        }
        return cell
    }
    
    
    
}


///3DTouch
extension CalendarListViewController : UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController?{
        let cell = previewingContext.sourceView as! CalendarListCollectionViewCell
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CalendarPeekViewController") as! CalendarPeekViewController
        vc.hasDelete = { [unowned self] (k : String ) in
            self.deleteAction(k)
        }
        vc.hasEdit = { [unowned self] (k : String ) in
            self.editAction(k)
        }
        var key = cell.nameLabel.text
        if key == "我" {
            key = UD_DATA
        } else {
        }
        vc.key = key!
        return vc
        
    }
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController){
        let vc = CalendarPopViewController()
        vc.key = (viewControllerToCommit as! CalendarPeekViewController).key
        let nav = UINavigationController(rootViewController: vc)
        nav.transitioningDelegate = self
        nav.modalPresentationStyle = .Custom
        self.presentViewController(nav, animated: true, completion: nil)
    }
}

extension CalendarListViewController : UIViewControllerTransitioningDelegate{
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let _ = selectCellIndexPath {
            return FlipTransition(presenting: true)
        }
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        self.reloadData()
        if let _ = selectCellIndexPath {
            return FlipTransition(presenting: false )
        }else {
            return SettingDataPresentationAnimationController(isPresenting: false)
        }
    }
}
extension CalendarListViewController : UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let index = indexPath.row % allKeyArr!.count
        let key = allKeyArr![index]
        
        let vc = CalendarPopViewController()
        vc.key = key
        let nav = UINavigationController(rootViewController: vc)
        nav.transitioningDelegate = self
        nav.modalPresentationStyle = .Custom
        
        selectCellIndexPath = indexPath
        selectCellFrame = view.convertRect(collectionView.cellForItemAtIndexPath(indexPath)!.frame , fromView: self.collection)
        
        self.presentViewController(nav, animated: true, completion: nil)
    }
}
extension CalendarListViewController : UIScrollViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            decelerateAction(scrollView)
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        decelerateAction(scrollView)
    }
    
    func decelerateAction(scrollView: UIScrollView) -> Void {
        var currentIndex = 0
        let index = (scrollView.contentOffset.x - 50 ) / ( UIScreen.mainScreen().bounds.width / 3 + 50) + 1
        
        if let data = allKeyArr {
            currentIndex = Int(index) % data.count
            collection!.scrollToItemAtIndexPath(NSIndexPath(forRow:  data.count * CYCLE_COUNT + currentIndex , inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        }
    }
}