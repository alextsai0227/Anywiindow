//
//  LoginViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/9.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import Firebase
class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var nameTxT: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var aviLoadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var fbView: UIView!
    
    
    var loginButton: FBSDKLoginButton! = FBSDKLoginButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        //  textField add left image view
        txtEmail.leftViewMode = UITextFieldViewMode.Always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let image = UIImage(named: "Email")
        imageView.image = image
        txtEmail.leftView = imageView
        nameTxT.leftViewMode = UITextFieldViewMode.Always
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let image2 = UIImage(named: "Name")
        imageView.image = image2
        nameTxT.leftView = imageView2
        txtPassword.leftViewMode = UITextFieldViewMode.Always
        let imageView3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let image3 = UIImage(named: "Password")
        ////////////////////////////////////////
        imageView.image = image3
        txtPassword.leftView = imageView3
        self.loginButton.hidden = false
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        self.nameTxT.delegate = self
        self.loginButton.frame.size = CGSize(width: UIScreen.mainScreen().bounds.width/6*5, height: 48)
        self.fbView.alpha = 0
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let naviMapViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SWRevealViewController")
                self.presentViewController(naviMapViewController, animated: true, completion: nil)
                
            } else {
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginButton.delegate = self
                self.loginButton.hidden = false
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        self.loginButton.center = self.fbView.center
        self.view.addSubview(loginButton)
        self.loginButton.hidden = false
        self.view.layoutIfNeeded()

    }
    override func viewDidAppear(animated: Bool) {
        self.loginButton.center = self.fbView.center
        self.view.addSubview(loginButton)
        self.loginButton.hidden = false
        self.view.layoutIfNeeded()
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(sender: AnyObject) {
    }

    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        self.nameTxT.resignFirstResponder()
        return true
    }
    @IBAction func tapView(sender: AnyObject) {
        self.view.endEditing(true)
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

extension LoginViewController: FBSDKLoginButtonDelegate{
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        loginButton.hidden = true
        aviLoadingSpinner.startAnimating()
        if let error = error{
            print(error.localizedDescription)
            return
        }
        if (error != nil){
            self.loginButton.hidden = false
            aviLoadingSpinner.stopAnimating()
        }else if(result.isCancelled) {
            self.loginButton.hidden = false
            aviLoadingSpinner.stopAnimating()
        }else{
            
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            let userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.setObject("\(FBSDKAccessToken.currentAccessToken().tokenString)", forKey: "fbToken")
            userDefault.synchronize()
            
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                if let err = error{
                    print(err.localizedDescription)
                    print(err)
                    return
                }
                let email = user?.email
                let username = user?.displayName
                var userValue = ["username": username!,"email": email!]
                
                //Push
                if let pushToken = NSUserDefaults.standardUserDefaults().objectForKey("UserPushToken"){
                    userValue["pushToken"] = "\(pushToken)"
                }
                print(userValue)
                let ref = FIRDatabase.database().reference()
                let uid = user?.uid
                ref.child("users").child(uid!).setValue(userValue)
            }
        }
        
        
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Did Log out")
        do{
            try FIRAuth.auth()?.signOut()
            
        } catch {
            print("sign out error: \(error)")
            
        }
        
    }
    
    @IBAction func toSignUpVC(sender: AnyObject) {
//        self.performSegueWithIdentifier("showSignUp", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showSignUp"{
//            let signUpVC = storyboard?.instantiateViewControllerWithIdentifier("SingUpViewController") as! SingUpViewController
//            
//        }
    }
}

