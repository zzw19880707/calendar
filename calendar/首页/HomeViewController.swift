//
//  HomeViewController.swift
//  calendar
//
//  Created by cnsyl066 on 15/10/27.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit
import Alamofire
import StarWars
public let TOP_ReuseIdentifier = "homeCollectionHeaderView"
public let cellIdentifier = "homeCollectionCell"
class HomeViewController: BaseViewController ,UIScrollViewDelegate  {

    
    var headerArr = [HomePageTopData]()
    var center = CGPointZero

    override func viewDidLoad() {
        super.viewDidLoad()
//        if traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: self.view)
//        }
        
        let rightBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        rightBtn .setImage(UIImage.init(named: "Icon_Settings"), forState: .Normal )
        rightBtn.addTarget(self, action: Selector("showSettingDataViewController"), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
       
        HttpRequest.getHomePageTopData { ( array : [HomePageTopData]?) -> Void in
            if let arr = array {
                self.headerArr = arr
                self.collectionView.reloadData()
            }
        }
        
        
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let scrollView = collectionView {
            setNavigationBarColor(scrollView)
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.yellowColor()
    }

    @IBOutlet weak var collectionView: UICollectionView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        setNavigationBarColor(scrollView)
    }
    /// 根据偏移量设置navigationbar的颜色及透明度
    func setNavigationBarColor (scrollView : UIScrollView){
        let color = view.backgroundColor
        let offsetY = scrollView.contentOffset.y
        if offsetY > 10 {
            let alpha = 1 - ((10 + 64 - offsetY ) / 64)
            navigationController?.navigationBar.lt_setBackgroundColor(color?.colorWithAlphaComponent(alpha))
        }else{
            navigationController?.navigationBar.lt_setBackgroundColor(color?.colorWithAlphaComponent(0))
        }
    }
}

extension HomeViewController {
    // MARK: - Action
    func showSettingDataViewController() {
        let mainVC = navigationController?.parentViewController as! MainViewController
        mainVC.presentSettingDataViewController()
    }
    
    @IBAction func unwind(segue : UIStoryboardSegue) {}
}

extension  HomeViewController : UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
        if indexPath.section == 0 {
            let collectionResuableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: TOP_ReuseIdentifier, forIndexPath: indexPath) as! TopReusableView
            collectionResuableView.dataArr = headerArr
            collectionResuableView.showDetail = { [unowned self ] ( center : CGPoint , index : Int )    in
                self.center = center
                self.performSegueWithIdentifier("movieDetail", sender: index)
            }
            return collectionResuableView
        }
        let collectionResuableView = UICollectionReusableView.init()
        return collectionResuableView

    }
    
    // MARK: - UICollectionViewDelegate
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
            return CGSize(width:  view.frame.size.width, height: section == 0 ? (view.frame.size.width * 3.5  / 3.75 ) : 0 )


    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        return CGSize(width: self.view.frame.width, height: 100)
    }

}

    // MARK: - 3D Touch
extension HomeViewController : UIViewControllerPreviewingDelegate{
    
    /// 获取top的cell位置。根据点击的点，来查找对应的cell坐标
    func getTopCellRect(center : CGPoint) -> (CGRect? , HomePageTopData? ){
        let topViewArr = collectionView.visibleSupplementaryViewsOfKind(UICollectionElementKindSectionHeader)
        
        if topViewArr.count > 0  {
            let topView = topViewArr[0] as! TopReusableView
            let cellArr = topView.collectionView.visibleCells() as! [TopViewCell]
            for cell  in cellArr {
                
                let rect = view.convertRect(cell.frame, fromView: topView.collectionView)
//                如果在cell上
                if CGRectContainsPoint( rect , center) {
                    let indexPath = topView.collectionView.indexPathForCell(cell)
                    let data = headerArr[indexPath!.row % headerArr.count]
                    return (rect ,data )
                }
            }
        }
        
        return (nil,nil)
    }
    
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController?{
       let nav = storyboard?.instantiateViewControllerWithIdentifier("MovieDetailNavigation") as! UINavigationController
        nav.transitioningDelegate = self
        nav.preferredContentSize = CGSize(width: 0, height: 400)
        let (rect,data ) = getTopCellRect(location)
        if let frame = rect {
            previewingContext.sourceRect = frame;
            let movieDate = nav.viewControllers[0] as! MovieDetailTableViewController
            movieDate.data = data
            return nav

        }
        return nil
    }
    
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController){
        self.presentViewController(viewControllerToCommit, animated: true, completion: nil)
    }
}

extension HomeViewController :UIViewControllerTransitioningDelegate {
    // MARK: - Navigation
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "movieDetail" {
            let nav = segue.destinationViewController as! UINavigationController
            let movieDetailVC =  nav.topViewController as! MovieDetailTableViewController
            if let index  = sender as? Int {
                movieDetailVC.data = headerArr[index  % headerArr.count]
            }
            nav.transitioningDelegate = self

        }
    }
    
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //        return StarWarsUIDynamicAnimator()
        //        return StarWarsUIViewAnimator()
        return StarWarsGLAnimator()
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MovieDetailAnimator(center: self.center)
    }


}
