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
var getnoti: Bool = false
class ViewController: UIViewController{
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var clockImageView: UIImageView!
    @IBOutlet weak var conutdownLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var mottoLabel: UILabel!
    @IBOutlet weak var mottoTopContrain: NSLayoutConstraint!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var mottoLabelUp: UILabel!
    @IBOutlet weak var windowNameLabel: UILabel!
    
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
    var quote = ["「我們常以困難為由，做為懶惰的藉口。」","「在我的西洋棋職涯裡，我不斷找新的挑戰，尋找別人沒做過的事。」","「不管你做什麼，創造一點不同，爭取回顧時可以說『那是我做的』的權利。」 ","「如果你不承認錯誤並負起責任，你必將再犯同樣錯誤。」","「沒有想像力的躍進、或夢想，就沒有其它可能給人的興奮。夢想終究也是計劃的一種形式。」","「願景不僅是個可能的景像，也是個更好自已的訴求、成就更多的召喚。」","「每天早晨，我父親要我看鏡子並複誦『今天會是很棒的一天；我可以，且我將做到。』」"]
    var author = ["– 昆體良 ","– 加里‧卡斯帕羅夫","– 麥克‧喬瑟夫","– 帕特·施蜜特","– 葛羅莉亞·斯坦能","– 羅莎貝絲‧肯特","– 吉娜·羅德里奎"]
    var isToolBarshow = true
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
//        self.timeView.backgroundColor = UIColor(red: 74/255, green: 90/255, blue: 198/255, alpha: 1)
//        self.pauseButton.hidden = true
//        self.muteButton.hidden = true
//        self.continueButton.hidden = true
//        self.cancelButton.hidden = true
//        self.startTimeButton.hidden = true
//        
//        self.timeView.layer.opacity = 0.0
        let index = Int(arc4random_uniform(UInt32(self.quote.count)))
        mottoLabel.text = quote[index]
        mottoLabelUp.text = quote[index]
        windowNameLabel.text = author[index]
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
            print("Failed to set audio session category.  Error: \(error)")
        }
        
        self.timeLabel.text = ""

        // Read URL
        self.readAudioURL()



    }
    override func viewWillAppear(animated: Bool) {
        self.readAudioURL()
        self.mottoLabelUp.hidden = true
        self.windowNameLabel.hidden = true
        self.mottoLabel.hidden = false
        self.timeLabel.hidden = false
        self.timeView.backgroundColor = UIColor(red: 74/255, green: 90/255, blue: 198/255, alpha: 1)
        self.pauseButton.hidden = true
        self.muteButton.hidden = true
        self.continueButton.hidden = true
        self.cancelButton.hidden = true
        self.startTimeButton.hidden = true
        
        self.timeView.layer.opacity = 0.0
        // imageView
        self.imageView.image = UIImage(named: window!.image[0])
        self.muteButton.setImage(UIImage(named: "mute"), forState: .Normal)
        self.view.layoutIfNeeded()
    }
    
    func readAudioURL(){
        let audioUrl:NSURL? = NSURL(string: "https://firebasestorage.googleapis.com/v0/b/anywindow-a910d.appspot.com/o/Merlion%E9%9F%B3%E6%AA%94.mp3?alt=media&token=ed2a279d-f412-40d6-b8fb-107dd2eb188d")
        if let url = audioUrl{
            self.avplayer = AVPlayer(URL: url)
        }
    }

    override func viewDidAppear(animated: Bool) {
        if self.avplayer == nil{
            self.readAudioURL()
        }

        //Audio Did Play
        self.avplayer?.play()
        // 30 Mins
        secondsCount = 20
        //Timeer 開始
        self.countDown()

        if countdownTimer == nil{
            self.countDown()
        }
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

        // Volume
    @IBAction func muteVolume(sender: AnyObject) {
        if self.avplayer?.volume != 0{
            self.avplayer?.volume = 0
            self.muteButton.setImage(UIImage(named: "opensound"), forState: .Normal)
        }else{
            self.avplayer?.volume = 1
            self.muteButton.setImage(UIImage(named: "mute"), forState: .Normal)
        }
    }
    @IBAction func pauseTime(sender: AnyObject) {
        self.avplayer?.pause()
        countdownTimer.invalidate()

        self.cancelButton.hidden = false
        self.cancelButton.layer.addAnimation(appearAnimation, forKey: nil) //加入動畫
        self.cancelButton.layer.opacity = 1.0
        self.continueButton.hidden = false
        self.continueButton.layer.addAnimation(appearAnimation, forKey: nil) //加入動畫
        self.continueButton.layer.opacity = 1.0
        self.pauseButton.hidden = true
        self.pauseButton.layer.addAnimation(disappearAnimation, forKey: nil) //加入動畫
        self.pauseButton.layer.opacity = 0.0
        self.muteButton.hidden = true
        self.muteButton.layer.addAnimation(disappearAnimation, forKey: nil) //加入動畫
        self.muteButton.layer.opacity = 0.0
    }
    @IBAction func continueTime(sender: AnyObject) {
        self.avplayer?.play()
        self.countDown()
        self.pauseButton.hidden = false
        self.pauseButton.layer.addAnimation(appearAnimation, forKey: nil)
        self.pauseButton.layer.opacity = 1.0
        self.muteButton.hidden = false
        self.muteButton.layer.addAnimation(appearAnimation, forKey: nil) //加入動畫
        self.muteButton.layer.opacity = 1.0
        self.cancelButton.hidden = true
        self.cancelButton.layer.addAnimation(disappearAnimation, forKey: nil) //加入動畫
        self.cancelButton.layer.opacity = 0.0
        self.continueButton.hidden = true
        self.continueButton.layer.addAnimation(disappearAnimation, forKey: nil) //加入動畫
        self.continueButton.layer.opacity = 0.0
        
    }
    @IBAction func cancelTime(sender: AnyObject) {
        self.avplayer = nil
        self.cancelButton.hidden = true
        self.continueButton.hidden = true
        self.startTimeButton.hidden = false
        self.timeLabel.text = ""
        self.conutdownLabel.text = ""
        
    }
    @IBAction func startTimeAgain(sender: AnyObject) {
        self.readAudioURL()
        // Load Movie URL Again

        //Audio Did Play
        self.avplayer?.play()
        // 30 Mins
        secondsCount = 20
        //Timeer 開始
        self.setTimer()
        self.startTimeButton.hidden = true
        self.pauseButton.hidden = false
        //
        if countdownTimer == nil{
            self.countDown()
        }
        
    }
    
    
    @IBAction func showTimeView(sender: AnyObject) {
        if self.continueButton.hidden == true{
        if isToolBarshow == true{
            if self.continueButton.hidden == true{
                self.pauseButton.hidden = false
                self.pauseButton.layer.addAnimation(appearAnimation, forKey: nil)
                self.pauseButton.layer.opacity = 1.0
                self.muteButton.hidden = false
                self.muteButton.layer.addAnimation(appearAnimation, forKey: nil) //加入動畫
                self.muteButton.layer.opacity = 1.0
                isToolBarshow = false
            }
        }else{
            self.pauseButton.hidden = true
            self.pauseButton.layer.addAnimation(disappearAnimation, forKey: nil) //加入動畫
            self.pauseButton.layer.opacity = 0.0
            self.muteButton.hidden = true
            self.muteButton.layer.addAnimation(disappearAnimation, forKey: nil) //加入動畫
            self.muteButton.layer.opacity = 0.0
            self.continueButton.hidden = true
            self.cancelButton.hidden = true
            isToolBarshow = true
        }
        }
    }
    
    
    
    func countDown(){
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.timerRun), userInfo: nil, repeats: true)
        print("\(NSDate.timeIntervalSinceReferenceDate())")
    }
    func timerRun(){
        secondsCount -= 1
        let minuts = secondsCount / 60
        let seconds = secondsCount - (minuts * 60)
        let timerOutput = NSString(format: "%02d:%02d", minuts, seconds)
        self.timeLabel.text = timerOutput as String
        self.conutdownLabel.text = "工作開始\(timerOutput)"
        print("timerOutput:\(seconds)")
        if secondsCount == 15{
            UIView.animateWithDuration(2.0, animations: { () -> Void in
                self.mottoLabel.hidden = true
                self.timeLabel.hidden = true
                self.blackView.alpha = 0.2
                self.timeView.layer.addAnimation(self.appearAnimation, forKey: nil) //加入動畫
                self.timeView.layer.opacity = 1.0
                self.mottoLabelUp.hidden = false
                self.windowNameLabel.hidden = false
                self.view.layoutIfNeeded()
            })
        }
        
        if secondsCount <= 5{
            self.timeView.backgroundColor = UIColor(red: 245/255, green: 68/255, blue: 89/255, alpha: 1)
        }
        if secondsCount == 0 {
            countdownTimer.invalidate()
            countdownTimer = nil
            self.avplayer = nil
            let setting = UIUserNotificationSettings(forTypes:
                [.Sound, .Alert ], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(setting)
            let destinationVC = storyboard?.instantiateViewControllerWithIdentifier("BreakViewController") as! BreakViewController
            destinationVC.window = self.window
            destinationVC.place = place
            self.presentViewController(destinationVC, animated: true, completion: nil)
        }
    }
    
    func setTimer(){
        self.countDown()
//        print("\(NSDate.timeIntervalSinceReferenceDate())")
    }
    
}


