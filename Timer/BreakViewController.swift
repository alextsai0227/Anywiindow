//
//  BreakViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/20.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class BreakViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var restButton: UIButton!
    @IBOutlet weak var endWorkButton: UIButton!
    @IBOutlet weak var windowImageView: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    var place:Place!
    var window: Window!
    var movieUrl: NSURL?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restButton.backgroundColor = UIColor(red: 88/255, green: 198/225, blue: 200/255, alpha: 1)
        self.restButton.layer.cornerRadius = 24
        self.endWorkButton.layer.cornerRadius = 24
        self.windowImageView.image = UIImage(named: window.image[0])
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func showMovie(sender: AnyObject) {
//        let avPlayerViewController = AVPlayerViewController()
//        var avMoviePlayer: AVPlayer?
//        if let url = movieUrl{
//            avMoviePlayer = AVPlayer(URL: url)
//            avPlayerViewController.player = avMoviePlayer
//        }
//        self.presentViewController(avPlayerViewController, animated: true, completion: {
//            avPlayerViewController.player?.play()
//        })
        let playerVC = storyboard?.instantiateViewControllerWithIdentifier("PlayerVC") as! PlayerViewController
            playerVC.window = window
            playerVC.place = place
        self.presentViewController(playerVC, animated: true, completion: nil)
    }
    @IBAction func checkWorkList(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let SWRevealViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SWRevealViewController")
        self.view.window!.rootViewController = SWRevealViewController
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }


}
