//
//  CityViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/12.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit

class CityViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    var hotel = [Hotel]()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var place = Place?()
    var window = Window?()
    var selectedWindow = Window?()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let spacingWidth = Float(10)
        let width = (Float(UIScreen.mainScreen().bounds.width) - spacingWidth * Float(2 + 1)) / 2
        self.collectionViewFlowLayout.itemSize = CGSize(width: CGFloat(width), height: CGFloat(width))
        if place?.city != nil{
            self.imageView.image = UIImage(named: (place?.city)!)
        }
        print("city:\(hotel)")
    }
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.hidden = true

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath)
        header.backgroundColor = UIColor.whiteColor()
        let citylabel = header.viewWithTag(1) as? UILabel
        let descriptionLabel = header.viewWithTag(2) as? UILabel
        citylabel?.text = hotel[0].name
        descriptionLabel?.text = "39 have work in the city"
        
        return header
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (place?.window.count)!
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WindowCollectionViewCell", forIndexPath: indexPath) as! WindowCollectionViewCell
        cell.imageView.image = UIImage(named: place!.window[indexPath.row].image[indexPath.row])
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedWindow = place?.window[indexPath.row]
        performSegueWithIdentifier("ShowWindow", sender: collectionView.cellForItemAtIndexPath(indexPath))
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowWindow"{
            let destinationViewcontroller = segue.destinationViewController as! ViewController
//            let selectedCell = sender as? UICollectionViewCell
//            let indexPathDidSelect = self.collectionView?.indexPathForCell(selectedCell!)
            destinationViewcontroller.window = selectedWindow
        }
    }
    @IBAction func backToLastViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func randomWindow(sender: AnyObject) {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let index = Int(arc4random_uniform(UInt32((place?.window.count)!)))
        viewController.window = place?.window[index]
        presentViewController(viewController, animated: true, completion: nil)

    
        
    }
    
    
}
