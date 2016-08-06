//
//  DataViewController.swift
//  AnyWindow
//
//  Created by 蔡舜珵 on 2016/8/1.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit
import Firebase
class DataViewController: UIViewController {
    var userDataArray = [DateData]()
    var place = Place.places
    var commentCount: Int = 0
    var rowAtIndexPath = 0
    var dataIndex: Int?
    var placeIndex = 9
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var workWindowCount: UILabel!
    @IBOutlet weak var wholeWork: UILabel!
    @IBOutlet weak var focusTime: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingSpinner.startAnimating()
        self.dataTableView.registerNib(UINib(nibName: "CityTableViewCell",bundle: nil), forCellReuseIdentifier: "CityTableViewCell")
        let ref = FIRDatabase.database().reference()
        let userUid = FIRAuth.auth()?.currentUser?.uid
        let postRef = ref.child(userUid!)
        postRef.observeEventType(.ChildAdded, withBlock: {snapshot in
            let userdata = DateData()
            userdata.dateTime = snapshot.key
            userdata.focusDuration = snapshot.value!.objectForKey("focus") as? String
            userdata.wholeWorkDuratuon = snapshot.value!.objectForKey("wholeWork") as? String
            userdata.workWindowcount = snapshot.value!.objectForKey("windowCount") as? String
            self.userDataArray.append(userdata)
            print("focusDuration\(userdata.focusDuration)")
            print("wholeWorkDuratuon\(userdata.wholeWorkDuratuon)")
            print("workWindowcount\(userdata.workWindowcount)")

            self.dateTimeLabel.text = self.userDataArray[self.userDataArray.count-1].dateTime!
            self.focusTime.text = self.userDataArray[self.userDataArray.count-1].focusDuration!
            self.wholeWork.text = self.userDataArray[self.userDataArray.count-1].wholeWorkDuratuon!
            self.workWindowCount.text = self.userDataArray[self.userDataArray.count-1].workWindowcount!
            self.dataIndex = self.userDataArray.count-1
            self.loadingSpinner.stopAnimating()
        })
        self.blueView.backgroundColor = UIColor(red: 69/255, green: 101/255, blue: 195/255, alpha: 1)
        self.titleLabel.textColor = UIColor.whiteColor()
        if self.revealViewController() != nil {
            self.menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    @IBAction func previousDate(sender: AnyObject) {
        if (self.dataIndex! - 1) < 0{
            self.dataIndex = userDataArray.count - 1
            self.dateTimeLabel.text = self.userDataArray[self.dataIndex!].dateTime!
            self.focusTime.text = self.userDataArray[self.dataIndex!].focusDuration!
            self.wholeWork.text = self.userDataArray[self.dataIndex!].wholeWorkDuratuon!
            self.workWindowCount.text = self.userDataArray[self.dataIndex!].workWindowcount!
        }else{
            self.dataIndex! -= 1
            self.dateTimeLabel.text = self.userDataArray[self.dataIndex!].dateTime!
            self.focusTime.text = self.userDataArray[self.dataIndex!].focusDuration!
            self.wholeWork.text = self.userDataArray[self.dataIndex!].wholeWorkDuratuon!
            self.workWindowCount.text = self.userDataArray[self.dataIndex!].workWindowcount!
        }
        if placeIndex <= 7{
            placeIndex = 9
            
        }else{
            placeIndex -= 1
        }
        self.dataTableView.reloadData()
    }
    
    @IBAction func nextDate(sender: AnyObject) {
        if (self.dataIndex! + 1) > userDataArray.count - 1{
            self.dataIndex = 0
            self.dateTimeLabel.text = self.userDataArray[self.dataIndex!].dateTime!
            self.focusTime.text = self.userDataArray[self.dataIndex!].focusDuration!
            self.wholeWork.text = self.userDataArray[self.dataIndex!].wholeWorkDuratuon!
            self.workWindowCount.text = self.userDataArray[self.dataIndex!].workWindowcount!
        }else{
            self.dataIndex! += 1
            self.dateTimeLabel.text = self.userDataArray[self.dataIndex!].dateTime!
            self.focusTime.text = self.userDataArray[self.dataIndex!].focusDuration!
            self.wholeWork.text = self.userDataArray[self.dataIndex!].wholeWorkDuratuon!
            self.workWindowCount.text = self.userDataArray[self.dataIndex!].workWindowcount!
        }
        if placeIndex >= 9{
            placeIndex = 7
        }else{
            placeIndex += 1
        }
        self.dataTableView.reloadData()

    }
}
extension DataViewController: UITableViewDataSource,UITableViewDelegate,CityTableViewCellDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return place[placeIndex].window.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CityTableViewCell", forIndexPath: indexPath)as! CityTableViewCell
        
        ////////////////讀取firebase///////////
        cell.windowImageView.image = UIImage(named: place[placeIndex].window[indexPath.row].image[0])
        cell.personCount.text = "\(Int(arc4random_uniform(10)))個人在這裡工作過"
        cell.windowName.text = place[placeIndex].window[indexPath.row].name
        cell.delegate = self
        let ref = FIRDatabase.database().reference()
        let postRef = ref.child((place[placeIndex].window[indexPath.row].name)).child("post")
        postRef.observeEventType(.Value, withBlock: {
            snapshot in
            self.commentCount = Int(snapshot.childrenCount)
            cell.commentCountLabel.text = "\(self.commentCount)"
            print(self.commentCount)
        })
        cell.havenotVisitImageView.hidden = true
        return cell
    }
    func goToCommentViewController(cell: CityTableViewCell) {
        rowAtIndexPath = (self.dataTableView.indexPathForCell(cell)?.row)!
        print("我看看\(rowAtIndexPath)")
        let commentVC = storyboard?.instantiateViewControllerWithIdentifier("CommentViewController") as! CommentViewController
        let selectedWindow = place[placeIndex].window[rowAtIndexPath]
        commentVC.window = selectedWindow
        commentVC.cityName = (place[placeIndex].city)
        commentVC.place = place[placeIndex]
        presentViewController(commentVC, animated: true, completion: nil)
        
    }
    func goToReadyPlayViewController(cell: CityTableViewCell){
        rowAtIndexPath = (self.dataTableView.indexPathForCell(cell)?.row)!
        let readyPlayViewController = storyboard?.instantiateViewControllerWithIdentifier("ReadyPlayViewController") as! ReadyPlayViewController
        readyPlayViewController.selectedWindow = place[placeIndex].window[rowAtIndexPath]
        readyPlayViewController.place = place[placeIndex]
        presentViewController(readyPlayViewController, animated: true, completion: nil)
    }
    
}
//        let calendar = NSCalendar.currentCalendar()
//        let components = calendar.components([.Year,.Day, .Month], fromDate: NSDate())
//        let date = "\(components.year)-\(components.month)-\(components.day)"
//        if FIRAuth.auth()?.currentUser != nil{
//            let postRef = ref.child("\(FIRAuth.auth()!.currentUser!.uid)").child("\(date)")
//            postRef.setValue(["focus":"03:00","wholeWork":"05:00","windowCount":"8"])
//        }

