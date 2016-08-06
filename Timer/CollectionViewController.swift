//
//  CollectionViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/29.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate  {
    var colletionImageArray = ["image_1","image_2","image_3"]
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCollectionView!.registerNib(UINib(nibName: "WellcomCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "WellcomCollectionViewCell")
        flowLayout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        self.startButton.backgroundColor = UIColor(red: 69/255, green: 101/225, blue: 195/255, alpha: 1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WellcomCollectionViewCell", forIndexPath: indexPath) as! WellcomCollectionViewCell
        cell.imageView.image = UIImage(named: colletionImageArray[indexPath.row])
        return cell
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageNum = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageControl!.currentPage = Int(pageNum)
    }
    @IBAction func goSignVC(sender: AnyObject) {
        let signInVC = storyboard?.instantiateViewControllerWithIdentifier("NavigateVC") 
        self.presentViewController(signInVC!, animated: false, completion: nil)
    }
    
}
