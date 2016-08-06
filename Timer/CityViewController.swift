//
//  SearchBarTableViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/6.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//
//
import UIKit
import Firebase

class CityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var anywindowButton: UIButton!
    @IBOutlet weak var windowTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    var commentCount: Int = 0
    var commentArray: [Comment?] = []
    var place = Place?()
    var window = Window?()
    var selectedWindow = Window?()
    var distance: Double?
    var rowAtIndexPath = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.windowTableView.registerNib(UINib(nibName: "CityTableViewCell",bundle: nil), forCellReuseIdentifier: "CityTableViewCell")
        self.windowTableView.registerNib(UINib(nibName: "CityTableViewCell2",bundle: nil), forCellReuseIdentifier: "CityTableViewCell2")
        if place?.city != nil{
            self.cityImageView.image = UIImage(named: (place?.city)!)
        }
        self.windowTableView.dataSource = self
        self.windowTableView.delegate = self
        let screensize = UIScreen.mainScreen().bounds.size
        let imageHeight = screensize.height/3
        self.windowTableView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0)
        

    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.layoutIfNeeded()
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return (place?.window.count)!
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("CityTableViewCell", forIndexPath: indexPath)as! CityTableViewCell

            ////////////////讀取firebase///////////
            cell.windowImageView.image = UIImage(named: place!.window[indexPath.row].image[0])
            cell.personCount.text = "\(Int(arc4random_uniform(10)))個人在這裡工作過"
            cell.windowName.text = place?.window[indexPath.row].name
            cell.delegate = self
            let ref = FIRDatabase.database().reference()
            let postRef = ref.child((place?.window[indexPath.row].name)!).child("post")
            postRef.observeEventType(.Value, withBlock: {
                snapshot in
                self.commentCount = Int(snapshot.childrenCount)
                cell.commentCountLabel.text = "\(self.commentCount)"
                print(self.commentCount)
            })
            if indexPath.row % 2 == 1{
                cell.havenotVisitImageView.image = UIImage(named: "")
            }
            
            return cell
        }else if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("CityTableViewCell2", forIndexPath: indexPath)as! CityTableViewCell2
            cell.descriptionlabel.text = place?.description
            if distance != nil{
                let distance = Int(self.distance!)
                cell.distance.text = "\(distance)公里"
            }
            cell.placeName.text = self.place?.city
            cell.windowCount.text = "工作地點(\(place!.window.count))"
            return cell
        }
        return UITableViewCell()
    }

    @IBAction func backToLastViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func randomWindow(sender: AnyObject) {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let index = Int(arc4random_uniform(UInt32((place?.window.count)!)))
        viewController.window = place?.window[index]
        viewController.place = place
        presentViewController(viewController, animated: true, completion: nil)
        
        
        
    }
    
    
}
extension CityViewController: CityTableViewCellDelegate{
    func goToCommentViewController(cell: CityTableViewCell) {
        rowAtIndexPath = (self.windowTableView.indexPathForCell(cell)?.row)!
        print("我看看\(rowAtIndexPath)")
        let commentVC = storyboard?.instantiateViewControllerWithIdentifier("CommentViewController") as! CommentViewController
        let selectedWindow = place?.window[rowAtIndexPath]
        commentVC.window = selectedWindow
        commentVC.cityName = (place?.city)!
        commentVC.place = place
        presentViewController(commentVC, animated: true, completion: nil)
        
    }
    func goToReadyPlayViewController(cell: CityTableViewCell){
        rowAtIndexPath = (self.windowTableView.indexPathForCell(cell)?.row)!
        let readyPlayViewController = storyboard?.instantiateViewControllerWithIdentifier("ReadyPlayViewController") as! ReadyPlayViewController
        readyPlayViewController.selectedWindow = place?.window[rowAtIndexPath]
        readyPlayViewController.place = place
        presentViewController(readyPlayViewController, animated: true, completion: nil)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        let screensize = UIScreen.mainScreen().bounds.size
        let imageHeight = screensize.height/3
        if (y < -imageHeight) {
            
            var frame = self.cityImageView.frame
            //MARK: 核心代码
            frame.origin.y = 0
            frame.size.height = -y
            self.cityImageView.frame = frame
            var anywindowButtonFrame = self.anywindowButton.frame
            anywindowButtonFrame.origin.y = 200 - (222.5 + y)
            self.anywindowButton.frame = anywindowButtonFrame

            
        }
        if (y > -imageHeight) {
            
            var frame = self.cityImageView.frame
            //MARK: 核心代码
            frame.origin.y = -(222.5 + y)
//            frame.origin.y = 0
//            frame.size.height = -y
            self.cityImageView.frame = frame
            var anywindowButtonFrame = self.anywindowButton.frame
            anywindowButtonFrame.origin.y = 200 - (222.5 + y)
            self.anywindowButton.frame = anywindowButtonFrame
        }
    }

}

//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        selectedWindow = place?.window[indexPath.row]
//
//        if indexPath.section == 1{
//            let readyPlayViewController = storyboard?.instantiateViewControllerWithIdentifier("ReadyPlayViewController") as! ReadyPlayViewController
//            readyPlayViewController.selectedWindow = selectedWindow
//            presentViewController(readyPlayViewController, animated: true, completion: nil)
//        }
//    }