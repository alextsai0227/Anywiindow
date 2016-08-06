//
//  WebViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/30.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit
import WebKit
import SafariServices
class WebViewController: UIViewController {
    @IBOutlet weak var orgWebView: UIWebView!
    var webView:WKWebView = WKWebView()
    var website:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: UIScreen.mainScreen().bounds)
        
        self.view.addSubview(webView)
        let url = NSURL(string: "https://www.google.com.tw/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwiq1pb0pJvOAhWIPI8KHYduDoMQFggcMAA&url=http%3A%2F%2Fwww.tigerair.com%2Ftw%2Fzh%2F&usg=AFQjCNHvxINKDwLOYYNH3xu8oHXDUJyEWw&sig2=zRfJ4fR2gtbPo171QpadEg")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
