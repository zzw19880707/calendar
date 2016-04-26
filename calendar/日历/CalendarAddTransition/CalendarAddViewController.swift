//
//  CalendarAddViewController.swift
//  calendar
//
//  Created by cnsyl066 on 16/4/15.
//  Copyright © 2016年 佐筱猪. All rights reserved.
//

import UIKit

//需要测试的dian
/*
    1.新增一个用户
        i.名字跟默认用户一致（不可能出现的，长度不够）    y
        ii.名字跟已有的一致                             y
        iii.不输入名字                               y(完全不输入、输入以后删除)
        iiii.正确的形式                              y
    2.修改一个用户
        i.默认用户修改(禁用)
            I.全部删除
            II.正确的模式（不修改名字）
            III.修改成其他
        ii.后增用户修改
            I.修改成默认用户
            II.修改成已有df用户
            III.全部删除
            IIII.正确模式（不修改）
 
 
 */
class CalendarAddViewController: BaseViewController {
    
    override func awakeFromNib() {
        
    }
    
    @IBOutlet weak var calendarView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    let SRC_WINDOW_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SRC_WINDOW_HEIGHT = UIScreen.mainScreen().bounds.size.height
    ///记录拖拽cell的索引
    var selectIndexPath : NSIndexPath?
    var isAddVC = true
    let duration : CGFloat = 0.75
    var _selectLayer : CALayer?
    var selectLayer : CALayer {
        get {
            guard let layer = _selectLayer else{
                
                
                _selectLayer = CALayer()
                _selectLayer!.cornerRadius = 25
                _selectLayer!.masksToBounds = true
                _selectLayer!.borderWidth = 1
                _selectLayer!.borderColor = UIColor.redColor().CGColor
                _selectLayer!.frame = CGRect(x: 10, y: 10 , width: 80 , height: 50)
                _selectLayer!.backgroundColor = UIColor.yellowColor().CGColor
                let layer = CALayer()
                layer.frame = CGRect(x: 0, y: 64, width: UIScreen.mainScreen().bounds.size.width , height: UIScreen.mainScreen().bounds.size.height - 64)
                layer.backgroundColor = UIColor.clearColor().CGColor
//                calendarView.layer.insertSublayer(layer, atIndex: 0)
//                self.view.layer.addSublayer(layer)
                calendarView.backgroundView!.layer.addSublayer(layer)
                layer.addSublayer(_selectLayer!)
                return _selectLayer!

            }
            return layer
        }
        
    }
//    用于执行动画，记录上一个选中点的位置
    var lastPostion : CGPoint?
//    删除时，如果选中的点是最后一个cell的位置，则为true
    var isLastCellSelected : Bool?
//    用于删除时，恢复到原始状态的
    var firstCellPosition : CGPoint?
    
    lazy var  bucketView : BucketView = {
        [unowned self] in
        let bucketView = BucketView(x: UIScreen.mainScreen().bounds.size.width / 2 - 50, y:  250 , width:100 )
        self.view.addSubview(bucketView)
        bucketView.backgroundColor = UIColor.redColor()
        bucketView.alpha = 0

        return bucketView
    }()

    
    
    private let reuseIdentifier = "Cell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataArr = CalendarData.getTypeByKey(self.key)

        
        textField.placeholder = "请输入用户名"
        if !isAddVC &&  key == UD_DATA {
            textField.enabled = false
        }
        
//        self.automaticallyAdjustsScrollViewInsets = false
        calendarView.dataSource = self
        calendarView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 50)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        calendarView.collectionViewLayout = layout
//        移动
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        calendarView.addGestureRecognizer(longPressGesture)
        calendarView.backgroundView = UIView()
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain , target: self, action: #selector(closeVC))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain , target: self, action: #selector(saveData))

//        添加
        let addCross = Cross()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        let addBtn = UIView()
        let width : CGFloat = 50
        addBtn.frame = CGRect(x: SRC_WINDOW_WIDTH - 50 - width , y: SRC_WINDOW_HEIGHT - 50 - width , width: width, height: width)
        addCross.frame = CGRect(x: width * 0.2 , y: width * 0.2 , width: width * 0.6 , height: width * 0.6)
        addCross.backgroundColor = UIColor.clearColor()
        addBtn.addSubview(addCross)
        addBtn.addGestureRecognizer(tapGesture)
        addBtn.backgroundColor = UIColor.redColor()
        addBtn.layer.cornerRadius = width / 2
        addBtn.layer.masksToBounds = true
        self.view.addSubview(addBtn)
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //        添加
        if isAddVC  {
            
        }
            //        编辑,填充数据
        else{
            textField.text = key
//            设置选中
            let index = NSDate().getTodayTypebyCurrentDate(CalendarData.getDateByKey(key) ,num:  dataArr.count)
            let indexPath  = NSIndexPath(forRow: index, inSection: 0)
            let cell = self.calendarView.cellForItemAtIndexPath(indexPath)
            self.selectLayer.position = cell!.center
            lastPostion = cell!.center
        }
    }
    var _oldKey : String?
    
    // WARNING:
    var key = UD_DATA {
        didSet {
            guard let _ = _oldKey else {
                if !isAddVC {//编辑是记录
                    _oldKey = key
                }
                return
            }
        }
    }
    
    var dataArr = [String]()
//    用于移动时，状态为删除时 恢复原有数据状态
    var tempArr : [String]?
    
}
    // MARK: - animate
extension CalendarAddViewController {
    
    
    func allCellBenginShake(){
        //            抖动动画
        let shakeAnimation = CAKeyframeAnimation()
        shakeAnimation.keyPath = "transform.rotation.z"
        shakeAnimation.values = [ -0.05 ,0.05]
        shakeAnimation.duration = 0.1
        shakeAnimation.repeatCount =   Float(INT32_MAX)
        for cell  in calendarView.visibleCells() as! [SettingSortCollectionViewCell]{
            cell.layer.addAnimation(shakeAnimation, forKey: "shake")
            cell.backgroundColor = UIColor.yellowColor()
        }
        if  let _ = lastPostion {
            self.selectLayer.hidden = true
        }
    }
    func allCellEndShake(gesture: UILongPressGestureRecognizer , endMove : Bool ){
        
        bucketView.alpha = 0 
        for cell  in calendarView.visibleCells() as! [SettingSortCollectionViewCell]{
            cell.layer.removeAnimationForKey("shake")
            cell.backgroundColor = UIColor.clearColor()
        }
        if  let _ = lastPostion {
            self.selectLayer.hidden = false
        }
        
        if endMove {
            let (maxExtent , realityExtent) = getExtent(gesture)
            if maxExtent * 0.6 - realityExtent > 0  {//删除
                calendarView.cancelInteractiveMovement()
                if let selectedIndexPath = selectIndexPath{
                    if  let position  = lastPostion {
                        if let flag = isLastCellSelected  where flag == true {
                            VOIndicatorAnimation.bounceMoveIndicator(self.selectLayer, fromPostion: position , toPosition: firstCellPosition!, duration: duration)
                            lastPostion = firstCellPosition!
                        }
                    }
                    if let cell  = calendarView.cellForItemAtIndexPath(selectedIndexPath){
                        cell.hidden = true
                        cell.backgroundColor = UIColor.purpleColor()
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)( 0.35 * Double( NSEC_PER_SEC) )), dispatch_get_main_queue()){
                        self.dataArr = self.tempArr!
                        self.dataArr.removeAtIndex(selectedIndexPath.row)
                        self.calendarView.reloadData()
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)( 0.02 * Double( NSEC_PER_SEC) )), dispatch_get_main_queue()){
                            if  let position  = self.lastPostion {
                                let sIndexPath = self.calendarView.indexPathForItemAtPoint(position)
                                if let indexPath = sIndexPath {
                                    self.opinionLastPositionIsLastSelected(indexPath)
                                }
                            }
                        }
                    }
                }
                isLastCellSelected = false
            }else{
                calendarView.endInteractiveMovement()
            }
        }
        selectIndexPath = nil

    }
    //获取最大的距离，和真是距离
    func getExtent (gesture: UILongPressGestureRecognizer) -> (maxExtent : CGFloat , realityExtent : CGFloat) {
        //  如果结束点在圈内
        let point = gesture.locationInView(gesture.view!)
        // 开始计算重叠的最大X、Y值
        let maxX =  bucketView.frame.size.width / 2  //+ dragView.frame.size.width / 2
        let maxY =  bucketView.frame.size.width / 2  //+ dragView.frame.size.height / 2
        // 最大距离
        let maxExtent = sqrt(maxX * maxX + maxY * maxY )
        // 实际值
        let realityX = fabs(bucketView.center.x - point.x )//dragView.center.x )
        let realityY = fabs(bucketView.center.y - point.y - 64) //dragView.center.y )

        let realityExtent = sqrt(realityX * realityX + realityY * realityY)
        return (maxExtent , realityExtent)
    }
    

}
    // MARK: - Action
extension CalendarAddViewController {
//    移动
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case UIGestureRecognizerState.Began:
            guard let selectedIndexPath = calendarView.indexPathForItemAtPoint(gesture.locationInView(calendarView))
                else {
                    
                    break
            }
            if dataArr.count == 2 {
                return
            }

            selectIndexPath = selectedIndexPath
            bucketView.alpha = 0.7
            allCellBenginShake()
            tempArr = dataArr
            calendarView.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
        case UIGestureRecognizerState.Changed:
            calendarView.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
            
            
            let (maxExtent , realityExtent) = getExtent(gesture)

            if realityExtent < maxExtent {
                //进度
                bucketView.startToMove(realityExtent :realityExtent , maxExtent: maxExtent)
            }else {//复原
                bucketView.recovery()
            }
            
            
        case UIGestureRecognizerState.Ended:
            allCellEndShake(gesture , endMove: true )

        default:
            calendarView.cancelInteractiveMovement()
            allCellEndShake(gesture ,endMove: false )
        }
        
        
        
    }
//    添加
    func tapAction() -> Void {
        let alertController = UIAlertController.init(title: "请输入新的班次名称", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textfield1:UITextField) -> Void in
            textfield1.placeholder = "班次名应少于3个字"
            
        }
        alertController.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: { [weak alertController ] (UIAlertAction) -> Void in
            if let alert = alertController {
                self.updateTextField(alert.textFields![0].text)
            }
        }))
        presentViewController(alertController, animated: true, completion: nil)
    }

    func updateTextField(string   : String?){
        if let text = string {
            let length = text.characters.count
            if length < 3 && length > 0 {
                if dataArr.count < 8 {
                    dataArr += [text]
                    calendarView.reloadData()
                }else {
                    alertMessage("最多只能有8个班次")
                }
            }else if length == 0 {
                
            }else {
                alertMessage("长度太长了")
            }
            
        }
    }
    
    func saveData() -> Void {
        textField.resignFirstResponder()
        
        
        //        添加
        if isAddVC {
            if let text = textField.text where text != "" {
                key = text
            }else {
                key = "newInfo"
            }
        }
            //        修改
        else{
            if let text = textField.text {
                key = text
            }else {
                //        获取传入值,如果设置了，则使用，否者设置为原始的自己的名字
                if let oldkey = _oldKey {
                    key = oldkey
                }else {
                    key = UD_DATA
                }
            }
            
        }
        
//        未修改
        if key == UD_DATA {
            if isAddVC {
                key += getName()
            }
        }else{
            if isAddVC {
                let allKeys = CalendarData.getAllKeys()
                if allKeys!.contains(key) {
                    key += getName()
                }
            }else {//1修改后的名没变，2修改后的名跟之前的重复.3正常
                if key == _oldKey {//1修改后的名没变，
                    
                }else if key != _oldKey {
                    let allKeys = CalendarData.getAllKeys()
                    if let _ = allKeys?.contains(key) {
                        key += getName()//2修改后的名跟之前的重复.
                    }else {//3正常
                        
                    }
                }
                
            }
        }
        guard let postion = lastPostion else {
            alertMessage("必须选中一个今天所对应的班次")
            return
        }
        if let index = calendarView.indexPathForItemAtPoint(postion)?.row {
            
            let selectDate = NSDate(timeIntervalSinceNow: -( Double(index) * 60 * 60 * 24 ) )
            print(selectDate)
            CalendarData.setDataByKey(key, type: dataArr, date: selectDate)

        }
        
        
        closeVC()
    }
    
    func closeVC() -> Void {
        textField.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func getName() -> String {
        let date = NSDate().timeIntervalSince1970
        let dateStr = "\(date)"
        let length = dateStr.characters.count
        let start = arc4random() % UInt32(length - 5)
        let str = (dateStr as NSString ).substringWithRange(NSRange(location:  Int(start), length : 4))
        let random = arc4random() % 10000
        return "_" + str + "_\(random)"
    }
}

extension CalendarAddViewController  : UICollectionViewDataSource  , UICollectionViewDelegate{
    
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
        cell.backgroundColor  = UIColor.clearColor()
        cell.hidden = false

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        dataArr.insert(dataArr.removeAtIndex(sourceIndexPath.row), atIndex: destinationIndexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        let position = cell!.center
        if let point = lastPostion {
            VOIndicatorAnimation.bounceMoveIndicator(self.selectLayer, fromPostion: point , toPosition: position, duration: duration)
        }else{
            VOIndicatorAnimation.opacityMoveIndicator(self.selectLayer, toPosition: position, duration: duration)
        }
        lastPostion = position
        self.opinionLastPositionIsLastSelected(indexPath)
    }
    ///判定当前选中的图层 对应的索引，是否是最后一个
    func opinionLastPositionIsLastSelected(indexPath : NSIndexPath ) -> Void {
        //            判断选中的图层是否为最后一个
        if indexPath.row == dataArr.count - 1 {
            isLastCellSelected = true
            if let _ = firstCellPosition{
            }else {
                if  let point = calendarView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0 ))?.center {
                    firstCellPosition = point
                }
            }
        }else {
            isLastCellSelected = false
        }
    }
}


extension CalendarAddViewController : UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let str = textField.text {
            if string == "\n" {
                textField.resignFirstResponder()
                return false
            }
            let s = (str as NSString).stringByReplacingCharactersInRange(range, withString: string)
            if s.characters.count > 6 {
                return false
            }
        }
        return true
    }
}

