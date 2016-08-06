//
//  CommentTableViewCell2.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/28.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit
protocol CommentTableViewCellDelegate: class{
    
    func goToWebViewController(cell: CommentTableViewCell2)
    //@objc 為了可以做optional
}

class CommentTableViewCell2: UITableViewCell {
    @IBOutlet weak var windowName: UILabel!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var organizationImageView: UIImageView!
    @IBOutlet weak var organizationNameLabel: UILabel!
    weak var delegate: CommentTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.organizationImageView.layer.cornerRadius = 15
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func toWebViewVC(sender: AnyObject) {
        delegate?.goToWebViewController(self)
    }
}
