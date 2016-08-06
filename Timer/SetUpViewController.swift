//
//  SetUpViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/30.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
class SetUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToSideMenu(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    @IBAction func logOut(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(LoginViewController, animated: true, completion: nil)
        

    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
