//
//  ReadyPlayViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/20.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit

class ReadyPlayViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rechooseButton: UIButton!
    @IBOutlet weak var startWorkButton: UIButton!
    
    var place:Place!
    var selectedWindow = Window?()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage(named: (selectedWindow?.image[0])!)
        self.nameLabel.text = "歡迎來到\(selectedWindow!.name)"
        self.startWorkButton.layer.cornerRadius = 24
        self.startWorkButton.backgroundColor = UIColor(red: 69/255, green: 101/255, blue: 195/255, alpha: 1)
//        self.rechooseButton.layer.borderWidth = 1
//        self.rechooseButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.rechooseButton.layer.cornerRadius = 24
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    @IBAction func goToViewController(sender: AnyObject) {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        viewController.window = selectedWindow
        viewController.place = place
        presentViewController(viewController, animated: true, completion: nil)
    
    }
    
    @IBAction func backToCityView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backTorootView(sender: AnyObject) {
        self.view.window!.rootViewController?.dismissViewControllerAnimated(false, completion: nil)

    }
}
