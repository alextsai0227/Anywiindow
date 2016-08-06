//
//  CommentViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/16.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//


import UIKit
import MessageComposerView
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import SDWebImage
import SafariServices
class CommentViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTextView: UITextField!
    @IBOutlet weak var shareWindowButton: UIButton!
    @IBOutlet weak var goWindowButton: UIButton!
    var cityName = ""
    var window = Window?()
    var place: Place!
    var composeView: MessageComposerView!
    var ref = FIRDatabaseReference.init()
    var user = FIRAuth.auth()?.currentUser
    var commentArray: [Comment?] = []
    var uid:String?
    var userPicData:String?
    var userPicURL:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableView 下移
        let screensize = UIScreen.mainScreen().bounds.size
        let imageHeight = screensize.height/3
        self.commentTableView.contentInset = UIEdgeInsetsMake(222, 0, 0, 0)
        print(window)
        self.imageView.image = UIImage(named: window!.image[0])
        //   tableView delegate
        self.commentTableView.delegate = self
        self.commentTableView.dataSource = self
        self.commentTableView.registerNib(UINib(nibName: "CommentTableViewCell",bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        self.commentTableView.registerNib(UINib(nibName: "CommentTableViewCell2",bundle: nil), forCellReuseIdentifier: "CommentTableViewCell2")

        self.commentTableView.estimatedRowHeight = 50
        self.commentTableView.rowHeight = UITableViewAutomaticDimension
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentViewController.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
    }
    override func viewWillAppear(animated: Bool) {
        self.view.layoutIfNeeded()
        if let user = FIRAuth.auth()?.currentUser {
            uid = user.uid
        }
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"])
        request.startWithCompletionHandler({ (connection, result, error) in
            if result != nil{
                let info = result as! NSDictionary
                if let imageURL = info.valueForKey("picture")?.valueForKey("data")?.valueForKey("url") as? String {
                    self.userPicURL = imageURL

                }
            }
        })
        self.getPost()
        
    }
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height
        })
    }
    @IBAction func sendPost(sender: AnyObject) {
        if self.commentTextView.text != ""{
            if user != nil {
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components([.Year,.Day, .Month], fromDate: NSDate())
                let ref = FIRDatabase.database().reference()
                let postRef = ref.child(window!.name).child("post").childByAutoId()
                postRef.setValue(["name":"\(user!.displayName!)","comment":"\(self.commentTextView.text!)","photoURL":"\(self.userPicURL!)","date":"\(components.year)/\(components.month)/\(components.day)"])
            } else{
                FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
                    if user == nil {
                        // User is signed in.
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let loginViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController")
                        self.presentViewController(loginViewController, animated: true, completion: nil)
                    }
                }
            }
            self.getPost()

        }
        self.commentTextView.text = nil
        self.view.endEditing(true)
        self.bottomConstraint.constant = 0

    }
    func getPost(){
        self.commentArray.removeAll()
        let ref = FIRDatabase.database().reference()
        let postRef = ref.child(window!.name).child("post")
        postRef.observeEventType(.ChildAdded, withBlock: {
            snapshot in
            let commentPost = Comment()
            commentPost.comment = snapshot.value!.objectForKey("comment") as? String
            commentPost.name = snapshot.value!.objectForKey("name") as? String
            commentPost.photoURL = snapshot.value!.objectForKey("photoURL") as? String
            commentPost.date = snapshot.value!.objectForKey("date") as? String
            self.commentArray.append(commentPost)
            print(commentPost.comment)
            if self.commentArray.count != 1{
                if self.commentArray[0]?.comment == self.commentArray[self.commentArray.count - 1]?.comment{
                    self.commentArray.removeAtIndex(0)
                }
            }
            self.commentTableView.reloadData()
        })
        
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//    func messageComposerSendMessageClickedWithMessage(message: String!) {
//        if user != nil {
//            let ref = FIRDatabase.database().reference()
//            let postRef = ref.child(window!.name).child("post").childByAutoId()
//            postRef.setValue(["name":"\(user!.displayName!)","comment":"\(composeView.messageTextView.text)","photoURL":"\(user!.displayName!)"])
//        } else{
//            FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
//                if user == nil {
//                    // User is signed in.
//                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let loginViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController")
//                    self.presentViewController(loginViewController, animated: true, completion: nil)
//                }
//            }
//        }
//        self.getPost()
//        
//    }
    @IBAction func tapView(sender: AnyObject) {
        self.view.endEditing(true)
        self.bottomConstraint.constant = 0

        
    }
    
    @IBAction func backToCityView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
extension CommentViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1{
            return commentArray.count
        }else{
            return 1
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
             let cell = commentTableView.dequeueReusableCellWithIdentifier("CommentTableViewCell2") as! CommentTableViewCell2
            cell.windowName.text = window?.name
            cell.placeName.text = cityName
            cell.delegate = self
            return cell
        }else{
            let cell = commentTableView.dequeueReusableCellWithIdentifier("CommentTableViewCell") as! CommentTableViewCell
            cell.nameLabel.text = commentArray[indexPath.row]!.name
            cell.commentLabel.text = commentArray[indexPath.row]!.comment
            cell.commentLabel.textColor = UIColor.lightGrayColor()
            cell.timeLabel.text = commentArray[indexPath.row]?.date
            cell.timeLabel.textColor = UIColor.lightGrayColor()
            let url = NSURL(string: (commentArray[indexPath.row]?.photoURL)!)
            cell.profileImageView.image?.circle
            cell.profileImageView?.sd_setImageWithURL(url, placeholderImage: nil)
            return cell
        }
//        //  load User Image
//        if let user = FIRAuth.auth()?.currentUser {
//            let name = user.displayName
//            //let email = user.email
//            let photoUrl = user.photoURL
//            //let uid = user.uid;
////            cell.nameLabel.text = name
//            
//            // reference to the storage service
//            let storage = FIRStorage.storage()
//            
//            // refer your particular storage service
//            let storageRef = storage.referenceForURL("gs://anywindow-a910d.appspot.com")
//            
//            let profilePicRef = storageRef.child(user.uid + "/profile_pic.jpg")
//            
//            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//            profilePicRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
//                if (error != nil) {
//                    print("Unable to download image")
//                    // Uh-oh, an error occurred!
//                } else {
//                    print("user already have the image, no need to download from fb")
//                    if (data != nil){
//                        cell.profileImageView.image = UIImage().imageWithImage(UIImage(data: data!)!, scaledToSize: CGSizeMake(44, 44)).circle
//                    }
//                    
//                    // Data for "images/island.jpg" is returned
//                    // ... let islandImage: UIImage! = UIImage(data: data!)
//                }
//            }
//            
//            if(cell.profileImageView.image == nil){
//                
//                let profilePic = FBSDKGraphRequest(graphPath: "me/picture",parameters: ["height":300,"width":300,"redirect":false], HTTPMethod: "GET")
//                profilePic.startWithCompletionHandler({(connection,result,error) -> Void in
//                    if(error == nil)
//                    {
//                        let dictionnary = result as? NSDictionary
//                        let data = dictionnary?.objectForKey("data")
//                        
//                        let urlPic = (data?.objectForKey("url"))! as! String
//                        
//                        if let imageData = NSData(contentsOfURL: NSURL(string: urlPic)!){
//                            let profilePicRef = storageRef.child(user.uid + "/profile_pic.jpg")
//                            
//                            let uploadTask = profilePicRef.putData(imageData, metadata: nil){
//                                metadata, error in
//                                if(error == nil){
//                                    //size,content type, or the download url
//                                    let downloadUrl = metadata!.downloadURL
//                                }else {
//                                    print("error in downloading image")
//                                }
//                            }
//                            cell.profileImageView.image = UIImage().imageWithImage(UIImage(data: imageData)!, scaledToSize: CGSizeMake(44, 44)).circle
//                            
//                        }
//                    }
//                    
//                })
//                
//            } else {
//                // No user is signed in.
//            }
//            // Do any additional setup after loading the view.
//        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        let screensize = UIScreen.mainScreen().bounds.size
        let imageHeight = screensize.height/3
        if (y < -imageHeight) {
            
            var frame = self.imageView.frame
            //MARK: 核心代码
            frame.origin.y = 0
            frame.size.height = -y
            self.imageView.frame = frame
            var shareButtonFrame = self.shareWindowButton.frame
            shareButtonFrame.origin.y = 200 - (222.5 + y)
            self.shareWindowButton.frame = shareButtonFrame
            var anywindowButtonFrame = self.goWindowButton.frame
            anywindowButtonFrame.origin.y = 200 - (222.5 + y)
            self.goWindowButton.frame = anywindowButtonFrame
            
            
        }
        if (y > -imageHeight) {
            
            var frame = self.imageView.frame
            //MARK: 核心代码
            frame.origin.y = -(222.5 + y)
            //            frame.origin.y = 0
            //            frame.size.height = -y
            self.imageView.frame = frame
            var shareButtonFrame = self.shareWindowButton.frame
            shareButtonFrame.origin.y = 200 - (222.5 + y)
            self.shareWindowButton.frame = shareButtonFrame
            var anywindowButtonFrame = self.goWindowButton.frame
            anywindowButtonFrame.origin.y = 200 - (222.5 + y)
            self.goWindowButton.frame = anywindowButtonFrame
        }
    }
    @IBAction func goReadyVC(sender: AnyObject) {
        let readyPlayViewController = storyboard?.instantiateViewControllerWithIdentifier("ReadyPlayViewController") as! ReadyPlayViewController
        readyPlayViewController.selectedWindow = window
        readyPlayViewController.place = place
        self.presentViewController(readyPlayViewController, animated: true, completion: nil)
        
    }
    @IBAction func shareWindow(sender: AnyObject) {
        let image = UIImage(named: window!.image[0])
        let array = ["享受你的任意窗", "www.any-window.com/", image!]
        let controller = UIActivityViewController(activityItems:array,applicationActivities: nil )
        self.presentViewController(controller, animated: true,
                                   completion: nil)
    }
    
}

extension CommentViewController: CommentTableViewCellDelegate{
    func goToWebViewController(cell: CommentTableViewCell2) {
        let url = NSURL(string: "https://www.google.com.tw/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwiq1pb0pJvOAhWIPI8KHYduDoMQFggcMAA&url=http%3A%2F%2Fwww.tigerair.com%2Ftw%2Fzh%2F&usg=AFQjCNHvxINKDwLOYYNH3xu8oHXDUJyEWw&sig2=zRfJ4fR2gtbPo171QpadEg")
        let controller = SFSafariViewController(URL: url!)
        self.presentViewController(controller, animated: true, completion: nil)

    }
}