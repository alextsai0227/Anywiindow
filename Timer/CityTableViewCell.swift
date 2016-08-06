//
//  CityTableViewCell.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/15.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//
@objc protocol CityTableViewCellDelegate: class{
    
    func goToCommentViewController(cell: CityTableViewCell)
    func goToReadyPlayViewController(cell: CityTableViewCell)
    //@objc 為了可以做optional
}
import UIKit

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var havenotVisitImageView: UIImageView!
    @IBOutlet weak var windowImageView: UIImageView!
    @IBOutlet weak var windowName: UILabel!
    @IBOutlet weak var messageButton: UIButton!    
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var personCount: UILabel!
    weak var delegate: CityTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.messageButton.backgroundColor = UIColor.clearColor()
        self.blueView.backgroundColor = UIColor(red: 88/255, green: 198/225, blue: 200/255, alpha: 1)
        self.blueView.layer.cornerRadius = 16
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    @IBAction func gotoComment(sender: AnyObject) {
        delegate?.goToCommentViewController(self)
    }
    @IBAction func gotoReadyPlayView(sender: AnyObject) {
        delegate?.goToReadyPlayViewController(self)
    }
    
}
