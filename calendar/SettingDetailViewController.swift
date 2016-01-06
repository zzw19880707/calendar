//
//  SettingDetailViewController.swift
//  calendar
//
//  Created by cnsyl066 on 15/11/5.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit

class SettingDetailViewController: SettingSortCollectionViewController ,UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let tap = UITapGestureRecognizer(target: self, action: "tapGesture:")
//        tap.numberOfTapsRequired = 2
//        collectionView!.addGestureRecognizer(tap)
    }

    var textField : UITextField?

    // MARK: - ACtion
    @IBAction func addClick(sender: AnyObject) {
        let alertController = UIAlertController.init(title: "请输入新的班次名称", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textfield:UITextField) -> Void in
            textfield.placeholder = "班次名应少于3个字"
            textfield.delegate = self
            self.textField = textfield
            
        }
        alertController.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: { (UIAlertAction) -> Void in

            self.updateTextField(self.textField!.text)

        }))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    lazy var bgView = UIView(frame: UIScreen.mainScreen().bounds )
    /*
    func tapGesture(tapGesture: UITapGestureRecognizer){
        bgView.backgroundColor = UIColor.whiteColor()
        view.addSubview(bgView)
        
        let visibleCellsArr = collectionView!.visibleCells() as! [SettingSortCollectionViewCell]
        for (index,cell) in visibleCellsArr.enumerate(){
            let frame = view.convertRect(cell.contentView.frame, fromView: cell)
            let cellSnapShotView = cell.snapshotViewAfterScreenUpdates(true)
            cellSnapShotView.frame = frame
            bgView.addSubview(cellSnapShotView)
            cellSnapShotView.tag = 100 + index
//          加入删除图标
            let imageView = UIImageView(image: UIImage(named: "减少"))
            imageView.frame = CGRect(x: (frame.origin.x + CGRectGetWidth(frame) - 18 ), y:( frame.origin.y - 13 ), width: 30, height: 30)
            imageView.contentMode = .Center
            imageView.tag = 1000 + index
            bgView.addSubview(imageView)
            
//            加入删除图标删除事件
            let tapGesture = UITapGestureRecognizer(target: self, action: "deleteAction:")
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(tapGesture)
            
//            抖动动画
            let shakeAnimation = CAKeyframeAnimation()
            shakeAnimation.keyPath = "transform.rotation.z"
            shakeAnimation.values = [ -0.05 ,0.05]
            shakeAnimation.duration = 0.1
            shakeAnimation.repeatCount =   Float(INT32_MAX)
            
            cellSnapShotView.layer.addAnimation(shakeAnimation, forKey: "shake")
        }
        
    }
//    删除图标删除事件
    func deleteAction(tap:UITapGestureRecognizer){
        dataArr.removeAtIndex((tap.view?.tag)! - 1000)
    }
    
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textfield: UITextField) -> Bool{
        updateTextField(textfield.text)
        return true
    }
    
    func updateTextField(string   : String?){
        if let text = string {
            let length = text.characters.count
            if length < 3 {
                if dataArr.count < 8 {
                    dataArr += [text]
                    collectionView?.reloadData()
                }else {
                    alertMessage("最多只能有8个班次")
                }
            }else if length == 0 {

            }else {
                alertMessage("长度太长了")
            }
            
        }
    }
    func alertMessage(string : String ){
        let alertController = UIAlertController.init(title: "提示", message: string, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)

    }
}
