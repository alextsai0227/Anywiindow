//
//  ReChooseWorkViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/24.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit

class ReChooseWorkViewController: UIViewController {
    @IBOutlet weak var startWorkButton: UIButton!
    @IBOutlet weak var reChooseButton: UIButton!
    var place: Place?
    var window: Window?
    override func viewDidLoad() {
        super.viewDidLoad()
         self.startWorkButton.backgroundColor = UIColor(red: 74/255, green: 90/255, blue: 198/255, alpha: 1)
//        self.reChooseButton.backgroundColor = UIColor.clearColor()
//        self.reChooseButton.layer.borderWidth = 1
//        self.reChooseButton.layer.borderColor = UIColor.whiteColor().CGColor
//        self.endWorkButton.backgroundColor = UIColor.clearColor()
//        self.endWorkButton.layer.borderWidth = 1
//        self.endWorkButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.reChooseButton.layer.cornerRadius = 24
        self.startWorkButton.layer.cornerRadius = 24
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func toViewController(sender: AnyObject) {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        viewController.window = place?.window[Int(arc4random_uniform(UInt32((place?.window.count)!)))]
        viewController.place = place
        presentViewController(viewController, animated: true, completion: nil)
    }
    @IBAction func reChooseWorkVC(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let SWRevealViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SWRevealViewController")
        self.view.window!.rootViewController = SWRevealViewController

    }
    
    
}
