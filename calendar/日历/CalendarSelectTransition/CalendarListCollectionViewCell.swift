//
//  CalendarListCollectionViewCell.swift
//  calendar
//
//  Created by cnsyl066 on 16/4/26.
//  Copyright © 2016年 佐筱猪. All rights reserved.
//

import UIKit

class CalendarListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    func setText(name : String , data : String) -> Void {
        nameLabel.text = name
        dataLabel.text = data
    }
}
