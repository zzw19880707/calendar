//
//  SettingDetailViewController.swift
//  calendar
//
//  Created by cnsyl066 on 15/11/5.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit

class SettingDetailViewController: UICollectionViewController ,UITextFieldDelegate {
    var dataArr : Array<String> {
        get {
            return CalendarData.getType()
        }
        set {
            CalendarData.setDataByType(newValue)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //为交互式移动工作设置标准手势），这个属性的添加使得我们可以用标准手势来对cell单元进行重新排序。该属性默认值为true，这意味着我们只需要重载一个方法就可以让它正常工作。
        installsStandardGestureForInteractiveMovement = false 
        let tap = UITapGestureRecognizer(target: self, action: #selector(deleteTapGesture(_:)))
        tap.numberOfTapsRequired = 2
        collectionView!.addGestureRecognizer(tap)
        
        let label = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height - 100 - 100  , width: self.view.frame.size.width - 100  , height: 100))
        label.text = "长按可以移动。双击可以删除"
        label.textAlignment = .Center
        self.view.addSubview(label)
        
    }

    var textField : UITextField?

    // MARK: - ACtion
    @IBAction func addClick(sender: AnyObject) {
        let alertController = UIAlertController(title: "请输入新的班次名称", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textfield:UITextField) -> Void in
            textfield.placeholder = "班次名应少于3个字"
            textfield.delegate = self
            self.textField = textfield
            
        }
        alertController.addAction(UIAlertAction(title: "确定", style: .Default, handler: { (UIAlertAction) -> Void in
            self.updateTextField(self.textField!.text)
        }))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func deleteTapGesture(tapGesture: UITapGestureRecognizer){
        if dataArr.count == 2 {
            return
        }
        if let selectedIndexPath = collectionView!.indexPathForItemAtPoint(tapGesture.locationInView(collectionView!)) {
            let alertController = UIAlertController(title: "确定要删除么？", message: nil, preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(title: "确定", style: .Default, handler: { (UIAlertAction) -> Void in
                
                self.dataArr.removeAtIndex(selectedIndexPath.row)
                self.collectionView!.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (UIAlertAction) -> Void in
                
            }))
            presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    
    func updateTextField(string   : String?){
        if let text = string {
            let length = text.characters.count
            if length < 3 && length > 0 {
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
        let alertController = UIAlertController(title: "提示", message: string, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)

    }
}
