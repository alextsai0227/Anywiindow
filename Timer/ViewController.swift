//
//  ViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/6/29.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase
import FBSDKLoginKit
class ViewController: UIViewController{
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var contiNueButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    var isPaused: Bool?
    var isTimerRunnung: Bool?
    var secondsCount = 0
    var countdownTimer: NSTimer!
    var reusableIdetifier = "Cell"
    var avplayer: AVPlayer?
    var imageName: String?
    var image: String?
    var imageArrayAdd: Array<String> = []
    let avPlayerViewController = AVPlayerViewController()
    var avMoviePlayer: AVPlayer?
    var place = Place?()
    var window = Window?()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景執行 
        var error: NSError?
        var success: Bool
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSessionCategoryPlayAndRecord,
                withOptions: .DefaultToSpeaker)
            success = true
        } catch let error1 as NSError {
            error = error1
            success = false
        }
        if !success {
            NSLog("Failed to set audio session category.  Error: \(error)")
        }
        
        // Button
        self.stopButton.hidden = true
        self.CancelButton.hidden = true
        self.contiNueButton.hidden = true
        self.timeLabel.text = "Hello World"
        // CollectionView Item Size
        self.layout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        // Read URL
        let audioUrl:NSURL? = NSURL(string: "http://www.youtube-mp3.org/get?video_id=nSDgHBxUbVQ&ts_create=1468226950&r=NjEuMjE2LjI1Ljky&h2=edc4904cc9d27327efebcf796b91ca2c&s=30257")
        if let url = audioUrl{
            self.avplayer = AVPlayer(URL: url)
        }
        //Read movie URL
        let movieUrl:NSURL? = NSURL(string: "http://techslides.com/demos/sample-videos/small.mp4")
        if let url = movieUrl{
            self.avMoviePlayer = AVPlayer(URL: url)
            self.avPlayerViewController.player = self.avMoviePlayer
        }

    }
    override func viewWillAppear(animated: Bool) {
        // Append Image for CollectionViewCell
        for i in 0...3{
            imageArrayAdd.append(window!.image[i])
        }
        // Read URL
        let audioUrl:NSURL? = NSURL(string: "http://www.youtube-mp3.org/get?video_id=nSDgHBxUbVQ&ts_create=1468226950&r=NjEuMjE2LjI1Ljky&h2=edc4904cc9d27327efebcf796b91ca2c&s=30257")
        if let url = audioUrl{
            self.avplayer = AVPlayer(URL: url)
        }
        navigationController?.navigationBarHidden = true

//      navigationController?.resignFirstResponder()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
        // Volume
    @IBAction func mute(sender: AnyObject) {
        if self.avplayer?.volume != 0{
            self.avplayer?.volume = 0
        }else{
            self.avplayer?.volume = 1
        }
    }

    @IBAction func startCounting(sender: AnyObject)  {
        //Audio Get URL
        if self.avplayer == nil{
            let audioUrl:NSURL? = NSURL(string: "http://www.youtube-mp3.org/get?video_id=nSDgHBxUbVQ&ts_create=1468226950&r=NjEuMjE2LjI1Ljky&h2=edc4904cc9d27327efebcf796b91ca2c&s=30257")
            if let url = audioUrl{
                self.avplayer = AVPlayer(URL: url)
            }
        }
        // Load Movie URL Again
        let movieUrl:NSURL? = NSURL(string: "http://techslides.com/demos/sample-videos/small.mp4")
        if let url = movieUrl{
            self.avMoviePlayer = AVPlayer(URL: url)
            self.avPlayerViewController.player = self.avMoviePlayer
        }
        //Audio Did Play
        self.avplayer?.play()
        // 30 Mins
        secondsCount = 10
        //Timeer 開始
        self.setTimer()
        self.startButton.hidden = true
        self.stopButton.hidden = false
        //
        if countdownTimer == nil{
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.timerRun), userInfo: nil, repeats: true)
            
        }
    }
    
    @IBAction func stopTime(sender: AnyObject) {
        self.avplayer?.pause()

        countdownTimer.invalidate()
        self.CancelButton.hidden = false
        self.contiNueButton.hidden = false
        self.stopButton.hidden = true
        print("countdownTimer:\(countdownTimer)")
        

    }
    
    @IBAction func cancelTime(sender: AnyObject) {
        self.avplayer = nil

        self.CancelButton.hidden = true
        self.contiNueButton.hidden = true
        self.startButton.hidden = false
        self.timeLabel.text = "Hello World"

    }
    
    
    @IBAction func continueTime(sender: AnyObject) {
        self.avplayer?.play()

        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.timerRun), userInfo: nil, repeats: true)
        
        self.CancelButton.hidden = true
        self.contiNueButton.hidden = true
        self.stopButton.hidden = false

        
    }
    
    
    
    
    func timerRun(){
        
        
        secondsCount -= 1
        let minuts = secondsCount / 60
        let seconds = secondsCount - (minuts * 60)
        let timerOutput = NSString(format: "%02d:%02d", minuts, seconds)
        self.timeLabel.text = timerOutput as String
        print("timerOutput:\(seconds)")
        if secondsCount == 0 {
            countdownTimer.invalidate()
            countdownTimer = nil
            self.startButton.hidden = false
            self.stopButton.hidden = true
            
            self.avplayer = nil
            self.presentViewController(self.avPlayerViewController, animated: true, completion: { () -> Void in
                self.avPlayerViewController.player?.play()
            })
        }
    
    }
    
    func setTimer(){
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.timerRun), userInfo: nil, repeats: true)
        print("\(NSDate.timeIntervalSinceReferenceDate())")
    }
    
    @IBAction func goTomap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logOut(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(LoginViewController, animated: true, completion: nil)

    }
    }


extension ViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArrayAdd.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reusableIdetifier, forIndexPath: indexPath) as! CollectionViewCell
        
        cell.imageView.image = UIImage(named: imageArrayAdd[indexPath.row])
        return cell
    }

}
