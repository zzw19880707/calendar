//
//  TopReusableView.swift
//  calendar
//
//  Created by cnsyl066 on 15/11/9.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit
import SDWebImage
class TopReusableView: UICollectionReusableView {
    
    
    var showDetail:( (center : CGPoint ,index : Int) -> Void )?
    
    let CYCLE_COUNT = 50
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var descLB: UILabel!
    @IBOutlet weak var scoreLB: UILabel!

    var index = 1
    var dataArr : [HomePageTopData]? {
        didSet {
            if let arr = dataArr {
                if arr.count > 0 {
                    bgImgView.sd_setImageWithURL(NSURL(string: arr[index].picture))
                    self.collectionView!.reloadData()
                    let indexPath = NSIndexPath(forRow: arr.count * CYCLE_COUNT , inSection: 0)
                    self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
                    
                    titleLb.text = arr[0].name
                    descLB.text = arr[0].message
                    scoreLB.text = arr[0].score
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        
    }
    
}

extension TopReusableView : UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var index = (scrollView.contentOffset.x - 50 ) / ( UIScreen.mainScreen().bounds.width / 3 + 50) + 1
       
        if index + 0.5 > ceil(index){
            index = ceil(index)
        }else {
            index = ceil(index) - 1
        }
        
        var currentIndex = 0
        if let data = dataArr {
            currentIndex = Int(index) % data.count
            let model = data[currentIndex]
            bgImgView.sd_setImageWithURL(NSURL(string: model.picture))
            titleLb.text = model.name
            descLB.text = model.message
            scoreLB.text = model.score
            
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        var currentIndex = 0
        let index = (scrollView.contentOffset.x - 50 ) / ( UIScreen.mainScreen().bounds.width / 3 + 50) + 1
        if let data = dataArr {
            currentIndex = Int(index) % data.count
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow:  data.count * CYCLE_COUNT + currentIndex , inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        }
    }

}

extension TopReusableView : UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let imgArr = dataArr {
            return imgArr.count * CYCLE_COUNT * 2
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("topViewCell", forIndexPath: indexPath) as! TopViewCell
        if let data = dataArr {
            let model = data[indexPath.row % data.count]
            cell.contentImgView.sd_setImageWithURL(NSURL(string: model.picture))
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath)!
        let center = self.convertPoint(cell.center, fromView: self.collectionView!)
        self.showDetail?(center: center ,index: indexPath.row)

    }
    

}