//
//  SingUpViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/25.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit

class SingUpViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var signUpTableView: UITableView!
    var email: String?
    var password: String?
    var userName: String?
    var confirmPassword: String?
    var about = ["Email","Username","Password","Confirm password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableView 註冊
        self.signUpTableView.registerNib(UINib(nibName: "SignUpTableViewCell",bundle: nil), forCellReuseIdentifier:"SignUpTableViewCell")
        self.signUpTableView.dataSource = self
        self.signUpTableView.delegate = self
//        navigationController?.navigationBar.backgroundColor = UIColor(red: 55/255, green: 86/255, blue: 195/255, alpha: 1)
//        navigationController?.navigationBarHidden = false
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.about.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.signUpTableView.dequeueReusableCellWithIdentifier("SignUpTableViewCell") as! SignUpTableViewCell
        cell.SingUptextField.placeholder = "\(self.about[indexPath.row])"
        return cell
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    @IBAction func submit(sender: AnyObject) {
        for i in 0...about.count-1{
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            let cell: SignUpTableViewCell = self.signUpTableView.cellForRowAtIndexPath(indexPath) as! SignUpTableViewCell
                let item: String = cell.SingUptextField.text!
                
                switch about[i]{
                    
                case "Email":
                    guard item.characters.count > 0 else {
                        let alert = UIAlertController(title: "you should input your email!", message: nil, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                        
                    }
                case "Username":
                    guard item.characters.count > 0 else {
                        let alert = UIAlertController(title: "you should input your username!", message: nil, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                        
                    }
                    
                case "Password":
                    guard item.characters.count >= 6 else {
                        let alert = UIAlertController(title: "you're password should  more than 6 digits!", message: nil, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                        
                    }
                    
                case "Confirm password":
                    guard item.characters.count >= 6 else {
                        let alert = UIAlertController(title: "you're password should  more than 6 digits!", message: nil, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                        
                    }
                    
                default:
                    print("dont update")
                }//end switch
    
        }

    }
}
