//
//  SideBarMenuViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/30.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SDWebImage
import FBSDKShareKit
class SideBarMenuViewController: UIViewController {
    var imageURL:String?
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 69/255, green: 101/255, blue: 195/255, alpha: 1)
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"])
        request.startWithCompletionHandler({ (connection, result, error) in
            print("我看看result\(result)")
            if result != nil{
                let info = result as! NSDictionary
                self.userNameLabel.text = info.valueForKey("name") as? String
                if let imageURL = info.valueForKey("picture")?.valueForKey("data")?.valueForKey("url") as? String {
                    self.userImageView.sd_setImageWithURL(NSURL(string: imageURL))
                }
            }else if error != nil{
                print("為什麼\(error)")
            }
            
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func goToSetupVC(sender: AnyObject) {
        let setUpVC = self.storyboard?.instantiateViewControllerWithIdentifier("SetUpViewController") as! SetUpViewController
        self.presentViewController(setUpVC, animated: false, completion: nil)
    }
    
    @IBAction func pickRandomWindow(sender: AnyObject) {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let place = Place.places[Int(arc4random_uniform(UInt32(Place.places.count)))]
        let index = Int(arc4random_uniform(UInt32((place.window.count))))
        viewController.window = place.window[index]
        viewController.place = place
        presentViewController(viewController, animated: true, completion: nil)

    }


}
