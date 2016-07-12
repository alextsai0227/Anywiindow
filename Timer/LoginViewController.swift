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
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var aviLoadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var fbView: UIView!
    
    
    var loginButton: FBSDKLoginButton! = FBSDKLoginButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.hidden = true
        self.txtUsername.delegate = self
        self.txtPassword.delegate = self
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let MapViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MapViewController")
                self.presentViewController(MapViewController, animated: true, completion: nil)
                
            } else {
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginButton.delegate = self
                self.loginButton.hidden = false
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        self.view.layoutIfNeeded()
        self.loginButton.center = self.fbView.center
        self.view.addSubview(loginButton)
        self.loginButton.hidden = false

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(sender: AnyObject) {
    }

    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        txtUsername.resignFirstResponder()
        txtPassword.resignFirstResponder()
        print("我愛你")
        return true
    }
    @IBAction func tapView(sender: AnyObject) {
        self.view.endEditing(true)
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
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
        print("User Log in")
        loginButton.hidden = true
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
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                if let err = error{
                    print(err.localizedDescription)
                    return
                }
                let email = user?.email
                let username = user?.displayName
                var userValue = ["username": username!,"email": email!]
                
                //Push
                if let pushToken = NSUserDefaults.standardUserDefaults().objectForKey("UserPushToken"){
                    userValue["pushToken"] = "\(pushToken)"
                }
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
    
}

