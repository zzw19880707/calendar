//
//  HamburgerView.swift
//  calendar
//
//  Created by cnsyl066 on 15/10/16.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

import UIKit

class HamburgerView: UIView {

//    设置图片
    let imageView: UIImageView! = UIImageView(image: UIImage(named: "Hamburger"))
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configure()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    // MARK: Private
    
    private func configure() {
        imageView.contentMode = UIViewContentMode.Center
        addSubview(imageView)
    }
    
    // MARK: RotatingView
    /// 根据fraction值进行旋转
    func rotate(fraction: CGFloat) {
        let angle = Double(fraction) * M_PI_2
        imageView.transform = CGAffineTransformMakeRotation(CGFloat(angle))
    }

}
