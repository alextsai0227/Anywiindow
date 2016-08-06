//
//  MapViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/7.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation
import AVKit
import Alamofire
import SwiftyJSON
import SDWebImage
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
    var image: Array<String>!
    var place = Place?()
    var window = Window?()
    var locationCoordinate2D: CLLocationCoordinate2D!
    var distance: Double!
    var windowCount: Int?
    var commentCount: Int?
}
class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{
///////////////////////////////變數///////////////////////////////////////////
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var anyCittyButton: UIButton!
    @IBOutlet weak var workWindowCount: UILabel!
    @IBOutlet weak var planeButtonLayout: NSLayoutConstraint!
    @IBOutlet weak var planeButtonYLayout: NSLayoutConstraint!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var imageUrl:String?
    var cityArray = [City]()
    let locatoinManager1 = CLLocationManager()
    var selectdAnnotation = CustomPointAnnotation()
    var userLocation = CLLocation()
    var center = ""
//////////////////////////////以下Function///////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

        self.anyCittyButton.layer.cornerRadius = 20
        self.anyCittyButton.imageView?.tintColor = UIColor.redColor()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

            // lolocatoinManager 取userlocation
        self.locatoinManager1.requestWhenInUseAuthorization()
        self.locatoinManager1.delegate = self
        self.locatoinManager1.requestLocation()
        self.locatoinManager1.startUpdatingLocation()

//        let userDefault = NSUserDefaults.standardUserDefaults()
//        Alamofire.request(.POST, apiString, parameters: ["auth_token":"\(userDefault.objectForKey("fbToken")!)"]).responseJSON{
//            response in
//            
//            print("我看看神馬response\(response)")
//        }

            // mapview delegate
        self.mapView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        self.planeButtonLayout.constant = 10
        self.infoView.hidden = true
        self.anyCittyButton.hidden = true
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.planeButtonYLayout.constant = 0


    }
    override func viewDidAppear(animated: Bool) {
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        self.view.layoutIfNeeded()

    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    override func viewDidDisappear(animated: Bool) {
        self.locatoinManager1.stopUpdatingLocation()
    }
    
    // MARK: - UpdateUserLocation Function

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locatoinManager1.stopUpdatingLocation()

        if locations.isEmpty == false {
            userLocation = locations.first!
            //             delta: the range of latitude/longitude
            let latDelta: CLLocationDegrees = 0.05
            let lonDelta: CLLocationDegrees = 0.05
            
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let location: CLLocationCoordinate2D = (userLocation.coordinate)
            let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
            
            self.mapView.setRegion(region, animated: true)
            locatoinManager1.distanceFilter = CLLocationDistance(10)
        }
        for place in Place.places {
            let annotation = CustomPointAnnotation()
            annotation.title = place.city
            annotation.coordinate = CLLocationCoordinate2DMake(Double(place.latitude)!, Double(place.longtitude)!)
            annotation.locationCoordinate2D = CLLocationCoordinate2D(latitude: Double(place.latitude)!, longitude: Double(place.longtitude)!)
            
            for data in place.window{
//                let annotation = CustomPointAnnotation()
//                annotation.title = data.name
//                annotation.coordinate = CLLocationCoordinate2DMake(Double(data.latitude)!, Double(data.longitude)!)
//                annotation.locationCoordinate2D = CLLocationCoordinate2D(latitude: Double(data.latitude)!, longitude: Double(data.longitude)!)
                annotation.imageName = data.name
                annotation.image = data.image
                annotation.place = place
                annotation.distance = GetDistance_Google(userLocation.coordinate, pointB: annotation.coordinate)
                annotation.windowCount = place.window.count
                self.mapView.addAnnotation(annotation)
            }
        }
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)

    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }
    func GetDistance_Google(pointA:CLLocationCoordinate2D , pointB:CLLocationCoordinate2D) -> Double
    {
        let EARTH_RADIUS:Double = 6378.137;
        
        let radlng1:Double = pointA.longitude * M_PI / 180.0;
        let radlng2:Double = pointB.longitude * M_PI / 180.0;
        
        let a:Double = radlng1 - radlng2;
        let b:Double = (pointA.latitude - pointB.latitude) * M_PI / 180;
        var s:Double = 2 * asin(sqrt(pow(sin(a/2), 2) + cos(radlng1) * cos(radlng2) * pow(sin(b/2), 2)));
        
        s = s * EARTH_RADIUS;
        s = (round(s * 10000) / 10000);
        return s;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ViewforAnnotation

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "SpotPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView?.canShowCallout = true
        }
        annotationView?.pinTintColor = UIColor(red: 51/255, green: 97/255, blue: 192/255, alpha: 1)
        return annotationView
    }
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
       
        // show infoView
        self.infoView.hidden = false
        self.anyCittyButton.hidden = false
        if let selectdAnnotation = view.annotation as? CustomPointAnnotation {
            self.infoLabel.text = selectdAnnotation.title
            self.workWindowCount.text = "\(selectdAnnotation.windowCount!)個工作地點"
        }
        
        //  把selected的Annotation存下來
        selectdAnnotation = (view.annotation as? CustomPointAnnotation)!
        var r = self.mapView.visibleMapRect
        let pt = MKMapPointForCoordinate(selectdAnnotation.coordinate)
        r.origin.x = pt.x - r.size.width * 0.5
        r.origin.y = pt.y - r.size.height * 0.25
        self.mapView.setVisibleMapRect(r, animated: true)
    }

    // MARK: - preparefor Segue

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ShowSearchTableView"{
//            let destinationViewController = segue.destinationViewController as! SearchTableViewController
//            destinationViewController.hotel = hotelArray
//        }
//    }
    @IBAction func goToCityViewController(sender: AnyObject) {
        let queue = dispatch_queue_create("Queue", DISPATCH_QUEUE_SERIAL)
        dispatch_sync(queue, { () -> Void in
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                var r = self.mapView.visibleMapRect
                let pt = MKMapPointForCoordinate(self.selectdAnnotation.coordinate)
                r.origin.x = pt.x - r.size.width * 0.5
                r.origin.y = pt.y - r.size.height * 0.25
                self.mapView.setVisibleMapRect(r, animated: true)
                self.planeButtonLayout.constant = 130
                self.planeButtonYLayout.constant = -350
                self.anyCittyButton.rotate180Degrees()
                self.view.layoutIfNeeded()
            })
        })
        NSTimer.scheduledTimerWithTimeInterval(1.3, target: self, selector: #selector(self.toCityVC), userInfo: nil, repeats: false)
    }

    // MARK: - GotoCityView
    func toCityVC(){
        let cityViewController = storyboard?.instantiateViewControllerWithIdentifier("CityViewController") as! CityViewController
        cityViewController.place = selectdAnnotation.place
        cityViewController.distance = selectdAnnotation.distance
        presentViewController(cityViewController, animated: true, completion: nil)
    }

    @IBAction func tapMapView(sender: AnyObject) {
        self.infoView.hidden = true
        self.anyCittyButton.hidden = true
    }
      // MARK: - SegmentControl
    


}


// MARK: - annotation 換圖片 and calloutAccessoryControlTapped
/*
 func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
 
 if annotation is MKUserLocation {
 //判斷大頭針是否為別的類別。如果不是MKPointAnnotation而是MKUserLocation的話，
 //就return離開
 return nil
 }
 
 let identifier = "MyPin" //新建一個之後來判斷可否回收的標記
 //試著看看是否有可重複使用的大頭針，如果有的話，存在變數 result 中
 var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
 if annotationView == nil{
 //如果沒有可重複使用的大頭針，則新建一個大頭針，並設定其顯示文字
 annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
 }else{
 //如果有的話，設定其顯示文字
 annotationView?.annotation = annotation
 }
 
 //設定點選可以秀出資訊
 //        annotationView?.canShowCallout = true
 //設定大頭針圖片
 //        annotationView?.image = UIImage(named: annotation.title!!)
 //        annotationView?.image = UIImage().imageWithImage(UIImage(named: "Taipei")!, scaledToSize: CGSizeMake(44, 44)).circle
 //讀入圖片，設定成Callout左邊顯示的View
 //        let starImageView = UIImageView(image: UIImage(named: "Star"))
 //        annotationView?.leftCalloutAccessoryView = starImageView
 //Callout的右邊，設定成按鈕
 //        let button = UIButton(type: .DetailDisclosure)
 //        button.addTarget(self, action: #selector(MapViewController.buttonPressed(_:)), forControlEvents: .TouchUpInside)
 //        annotationView?.rightCalloutAccessoryView = button
 
 
 //回傳大頭針
 return annotationView
 }

 func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
 if control == view.rightCalloutAccessoryView {
 if let annotation = view.annotation as? CustomPointAnnotation {
 let cityViewController = storyboard?.instantiateViewControllerWithIdentifier("CityViewController") as! CityViewController
 cityViewController.place = selectdAnnotation.place
 cityViewController.hotel = hotelArray
 cityViewController.distance = selectdAnnotation.distance
 presentViewController(cityViewController, animated: true, completion: nil)
 print("hotelarray:\(hotelArray)")
 
 }
 
 }
 }
 @IBAction func segmentChangeView(sender: AnyObject) {
 self.performSegueWithIdentifier("ShowSearchTableView", sender: nil)
 self.navigationController?.navigationBar.translucent = true
 self.segment.selectedSegmentIndex = 0
 }
 
 @IBAction func logOut(sender: AnyObject) {
 try! FIRAuth.auth()!.signOut()
 
 FBSDKAccessToken.setCurrentAccessToken(nil)
 
 let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
 let LoginViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController")
 self.presentViewController(LoginViewController, animated: true, completion: nil)
 
 }
 */