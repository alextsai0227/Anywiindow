//
//  CityTableViewCell2.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/19.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit

class CityTableViewCell2: UITableViewCell {
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var windowCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
