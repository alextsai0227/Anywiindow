//
//  PlayerViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/24.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
private var playbackLikelyToKeepUpContext = 0

class PlayerViewController: UIViewController {
    var place: Place!
    var window: Window!
    var avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var timeObserver: AnyObject!
    let loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    let appearAnimation : CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0   //設定動畫初始值
        animation.toValue = 1.0     //設定動畫結束值
        animation.duration = 0.5    //設定動畫時間
        return animation
    }()
    let disappearAnimation : CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 0.5
        return animation
    }()
    var isToolsHidden = true
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var clockImage: UIImageView!
    @IBOutlet weak var remainigTime: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var windowNameLabel: UILabel!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var lastWorkLabel: UILabel!
    @IBOutlet weak var windowNameCenterLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blackColor()
        self.blueView.backgroundColor = UIColor(red: 22/255, green: 204/22, blue: 203/255, alpha: 1)
        self.pauseButton.hidden = true
        self.muteButton.hidden = true
        self.continueButton.hidden = true
        self.cancelButton.hidden = true
        self.blueView.hidden = true
        self.windowNameLabel.hidden = true
        self.cityNameLabel.hidden = true
        self.remainingTimeLabel.text = ""
        self.windowNameLabel.text = window.name
        self.cityNameLabel.text = place.city
        self.windowNameCenterLabel.text = window.name
        
        // An AVPlayerLayer is a CALayer instance to which the AVPlayer can
        // direct its visual output. Without it, the user will see nothing.
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        view.layer.insertSublayer(avPlayerLayer, atIndex: 0)
        let url = NSURL(string: "https://firebasestorage.googleapis.com/v0/b/anywindow-a910d.appspot.com/o/_1Video5x.mp4?alt=media&token=1522eef4-af04-4850-abe9-af67dcd4b321")
        let playerItem = AVPlayerItem(URL: url!)
        avPlayer.replaceCurrentItemWithPlayerItem(playerItem)
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
        timeObserver = avPlayer.addPeriodicTimeObserverForInterval(timeInterval,
                                                                   queue: dispatch_get_main_queue()) { (elapsedTime: CMTime) -> Void in
                                                                    
                                                                    print("elapsedTime now:", CMTimeGetSeconds(elapsedTime))
                                                                    self.observeTime(elapsedTime)
                                                                    
        }
        self.remainigTime.textColor = UIColor.whiteColor()
        loadingIndicatorView.hidesWhenStopped = true
        view.addSubview(loadingIndicatorView)
        avPlayer.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp",
                             options: .New, context: &playbackLikelyToKeepUpContext)
    }
    deinit {
        avPlayer.removeTimeObserver(timeObserver)
        avPlayer.removeObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp")

    }
    private func updateTimeLabel(elapsedTime elapsedTime: Float64, duration: Float64) {
        let timeRemaining: Float64 = CMTimeGetSeconds(avPlayer.currentItem!.duration) - elapsedTime
        self.remainigTime.text = String(format: "開始休息%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
        self.remainingTimeLabel.text = String(format: "開始休息%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
        if timeRemaining == 0{
            let reChooseVC = storyboard?.instantiateViewControllerWithIdentifier("ReChooseWorkViewController") as! ReChooseWorkViewController
            self.presentViewController(reChooseVC, animated: true, completion: nil)
        }
        if elapsedTime >= 5{
            self.blackView.alpha = 0
            self.blueView.hidden = false
            self.windowNameLabel.hidden = false
            self.cityNameLabel.hidden = false
            self.remainingTimeLabel.hidden = true
            self.lastWorkLabel.hidden = true
            self.windowNameCenterLabel.hidden = true
        }
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?,
                                         change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if context == &playbackLikelyToKeepUpContext {
            if avPlayer.currentItem!.playbackLikelyToKeepUp {
                loadingIndicatorView.stopAnimating()
            } else {
                loadingIndicatorView.startAnimating()
            }
        }
    }
    
    private func observeTime(elapsedTime: CMTime) {
        let duration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        if isfinite(duration) {
            loadingIndicatorView.stopAnimating()
            let elapsedTime = CMTimeGetSeconds(elapsedTime)
            updateTimeLabel(elapsedTime: elapsedTime, duration: duration)
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadingIndicatorView.startAnimating()
        avPlayer.play() // Start the playback
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Layout subviews manually
        avPlayerLayer.frame = view.bounds
        loadingIndicatorView.center = CGPoint(x: CGRectGetMidX(view.bounds), y: CGRectGetMidY(view.bounds))

    }
    
    // Force the view into landscape mode (which is how most video media is consumed.)
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    @IBAction func muteVolume(sender: AnyObject) {
        if self.avPlayer.volume != 0{
            self.avPlayer.volume = 0
            self.muteButton.setImage(UIImage(named: "opensound"), forState: .Normal)
        }else{
            self.avPlayer.volume = 1
            self.muteButton.setImage(UIImage(named: "mute"), forState: .Normal)
        }
    }
    @IBAction func pausePlayer(sender: AnyObject) {
        avPlayer.pause()
        self.pauseButton.hidden = true
        self.pauseButton.layer.addAnimation(disappearAnimation, forKey: nil)
        self.pauseButton.layer.opacity = 0
        self.muteButton.hidden = true
        self.muteButton.layer.addAnimation(disappearAnimation, forKey: nil)
        self.muteButton.layer.opacity = 0
        self.continueButton.hidden = false
        self.continueButton.layer.addAnimation(appearAnimation, forKey: nil)
        self.continueButton.layer.opacity = 1
        self.cancelButton.hidden = false
        self.cancelButton.layer.addAnimation(appearAnimation, forKey: nil)
        self.cancelButton.layer.opacity = 1

     
    }
    @IBAction func continuePlay(sender: AnyObject) {
        avPlayer.play()
        self.pauseButton.hidden = false
        self.pauseButton.layer.addAnimation(appearAnimation, forKey: nil)
        self.pauseButton.layer.opacity = 1
        self.muteButton.hidden = false
        self.muteButton.layer.addAnimation(appearAnimation, forKey: nil)
        self.muteButton.layer.opacity = 1
        self.continueButton.hidden = true
        self.continueButton.layer.addAnimation(disappearAnimation, forKey: nil)
        self.continueButton.layer.opacity = 0
        self.cancelButton.hidden = true
        self.cancelButton.layer.addAnimation(disappearAnimation, forKey: nil)
        self.cancelButton.layer.opacity = 0

    }
    @IBAction func cancelPlay(sender: AnyObject) {
        let reChooseVC = storyboard?.instantiateViewControllerWithIdentifier("ReChooseWorkViewController") as! ReChooseWorkViewController
        reChooseVC.place = place
        reChooseVC.window = window
        self.presentViewController(reChooseVC, animated: true, completion: nil)
    }

    @IBAction func goCommentVC(sender: AnyObject) {
        avPlayer.pause()
        let commentVC = storyboard?.instantiateViewControllerWithIdentifier("CommentViewController") as! CommentViewController
        
        commentVC.window = window
        commentVC.cityName = place.city
        print(commentVC.window?.name)
        self.presentViewController(commentVC, animated: true, completion: nil)
     }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showComment"{
            let commentVC = storyboard?.instantiateViewControllerWithIdentifier("CommentViewController") as! CommentViewController
            
            commentVC.window = window
            commentVC.cityName = place.city
            print(commentVC.window?.name)
        }
        
    }

    @IBAction func showTools(sender: AnyObject) {
        if self.continueButton.hidden == true{
            if isToolsHidden{
                self.pauseButton.hidden = false
                self.pauseButton.layer.addAnimation(appearAnimation, forKey: nil)
                self.pauseButton.layer.opacity = 1
                self.muteButton.hidden = false
                self.muteButton.layer.addAnimation(appearAnimation, forKey: nil)
                self.muteButton.layer.opacity = 1
                isToolsHidden = false
            }else{
                self.pauseButton.hidden = true
                self.pauseButton.layer.addAnimation(disappearAnimation, forKey: nil)
                self.pauseButton.layer.opacity = 0
                self.muteButton.hidden = true
                self.muteButton.layer.addAnimation(disappearAnimation, forKey: nil)
                self.muteButton.layer.opacity = 0
                self.continueButton.hidden = true
                self.cancelButton.hidden = true
                isToolsHidden = true
                
            }
        }
    }

}

//    @IBAction func showTools(sender: AnyObject) {
//        if isToolsHidden{
//            self.blueView.hidden = false
//            self.blueView.layer.addAnimation(appearAnimation, forKey: nil)
//            self.blueView.layer.opacity = 1
//            self.pauseButton.hidden = false
//            self.pauseButton.layer.addAnimation(appearAnimation, forKey: nil)
//            self.pauseButton.layer.opacity = 1
//            self.muteButton.hidden = false
//            self.muteButton.layer.addAnimation(appearAnimation, forKey: nil)
//            self.muteButton.layer.opacity = 1
//            self.continueButton.hidden = false
//            self.continueButton.layer.addAnimation(appearAnimation, forKey: nil)
//            self.continueButton.layer.opacity = 1
//            self.cancelButton.hidden = false
//            self.cancelButton.layer.addAnimation(appearAnimation, forKey: nil)
//            self.cancelButton.layer.opacity = 1
//            self.windowNameLabel.hidden = false
//            self.windowNameLabel.layer.addAnimation(appearAnimation, forKey: nil)
//            self.windowNameLabel.layer.opacity = 1
//            self.shareViewButton.hidden = false
//            self.shareViewButton.layer.addAnimation(appearAnimation, forKey: nil)
//            self.shareViewButton.layer.opacity = 1
//            self.mapViewButton.hidden = false
//            self.mapViewButton.layer.addAnimation(appearAnimation, forKey: nil)
//            self.mapViewButton.layer.opacity = 1
//            self.commentViewButton.hidden = false
//            self.commentViewButton.layer.addAnimation(appearAnimation, forKey: nil)
//            self.commentViewButton.layer.opacity = 1
//            isToolsHidden = false
//        }else{
//            self.blueView.layer.addAnimation(disappearAnimation, forKey: nil)
//            self.blueView.layer.opacity = 0
//            self.pauseButton.layer.addAnimation(disappearAnimation, forKey: nil)
//            self.pauseButton.layer.opacity = 0
//            self.muteButton.layer.addAnimation(disappearAnimation, forKey: nil)
//            self.muteButton.layer.opacity = 0
//            self.continueButton.layer.addAnimation(disappearAnimation, forKey: nil)
//            self.continueButton.layer.opacity = 0
//            self.cancelButton.layer.addAnimation(disappearAnimation, forKey: nil)
//            self.cancelButton.layer.opacity = 0
//            self.windowNameLabel.layer.addAnimation(disappearAnimation, forKey: nil)
//            self.windowNameLabel.layer.opacity = 0
//            self.shareViewButton.layer.addAnimation(disappearAnimation, forKey: nil)
//            self.shareViewButton.layer.opacity = 0
//            self.mapViewButton.layer.addAnimation(disappearAnimation, forKey: nil)
//            self.mapViewButton.layer.opacity = 0
//            self.commentViewButton.layer.addAnimation(disappearAnimation, forKey: nil)
//            self.commentViewButton.layer.opacity = 0
//            isToolsHidden = true
//        }
//    }

//        let calendar = NSCalendar.currentCalendar()
//        let components = calendar.components([.Year,.Day, .Month], fromDate: NSDate())
//        let date = "\(components.year)-\(components.month)-\(components.day)"
//        let ref = FIRDatabase.database().reference()
//        if FIRAuth.auth()?.currentUser != nil{
//            let postRef = ref.child("\(FIRAuth.auth()!.currentUser!.uid)").child("\(date)")
//            postRef.setValue(["country":"\(self.place.country)","city":"\(self.place.city)","description":"\(self.place.description)","latitude":"\(self.place.latitude)","longtitude":"\(self.place.longtitude)"])
//            postRef.child("window").setValue(["name":"\(self.window.name)","image": "\(self.window.image[0])"])
//        }
