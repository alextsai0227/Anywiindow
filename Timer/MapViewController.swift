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
class MapViewController: UIViewController,MKMapViewDelegate{
    var hotelArray = [Hotel]()
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    var selectdAnnotation = CustomPointAnnotation()
    class CustomPointAnnotation: MKPointAnnotation {
        var imageName: String!
        var image: Array<String>!
        var place = Place?()
//        var window = Window?()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String = "http://data.taipei/opendata/datalist/apiAccess"
        Alamofire.request(.GET, urlString, parameters: ["scope": "resourceAquire","rid": "6f4e0b9b-8cb1-4b1d-a5c4-febd90f62469","limit": "3","offset": "0"]).responseJSON{
            response in
            if let data = response.result.value{
                let json = JSON(data)
                let hotelList = json["result"]["results"].arrayValue
                
                for hotel in hotelList{
                    let hotels = Hotel()
                    hotels.latitude = hotel["latitude"].stringValue
                    hotels.name = hotel["stitle"].stringValue
                    hotels.longtitude = hotel["longitude"].stringValue
                    self.hotelArray.append(hotels)
                    
                    print(hotels.latitude)
                    print("long:\(hotels.longtitude)")
                    print("12345\(self.hotelArray[0].latitude)")
                }
                for hotel in self.hotelArray{
                    let annotation = CustomPointAnnotation()
                    annotation.title = hotel.name
                    annotation.coordinate = CLLocationCoordinate2DMake(Double(hotel.latitude!)!, Double(hotel.longtitude!)!)
                    annotation.imageName = hotel.name
                    self.mapView.addAnnotation(annotation)
                    print("anno\(annotation)")
                }
            }
        }
        // mapview load annotation
        self.mapView.delegate = self
        
        for place in Place.places {
            for data in place.window{
            let annotation = CustomPointAnnotation()
            annotation.title = data.name
            annotation.coordinate = CLLocationCoordinate2DMake(Double(data.latitude)!, Double(data.longitude)!)
            annotation.imageName = data.name
            annotation.image = data.image
            annotation.place = place
            self.mapView.addAnnotation(annotation)
        
            }
        }
        
        
        
        
    }
    override func viewWillAppear(animated: Bool) {
        self.infoView.hidden = true
    }
    override func viewDidAppear(animated: Bool) {
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
        annotationView?.canShowCallout = true
        //設定大頭針圖片
//        annotationView?.image = UIImage(named: annotation.title!!)
        annotationView?.image = UIImage().imageWithImage(UIImage(named: "Taipei")!, scaledToSize: CGSizeMake(44, 44)).circle
        //讀入圖片，設定成Callout左邊顯示的View
        let starImageView = UIImageView(image: UIImage(named: "Star"))
        annotationView?.leftCalloutAccessoryView = starImageView
        //Callout的右邊，設定成按鈕
        let button = UIButton(type: .DetailDisclosure)
        button.addTarget(self, action: #selector(MapViewController.buttonPressed(_:)), forControlEvents: .TouchUpInside)
        annotationView?.rightCalloutAccessoryView = button

        
        //回傳大頭針
        return annotationView
    }
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        // hide infoView
        self.infoView.hidden = false
        if let selectdAnnotation = view.annotation as? CustomPointAnnotation {
            self.infoLabel.text = selectdAnnotation.imageName
        }
            //  把selected的Annotation存下來
        selectdAnnotation = (view.annotation as? CustomPointAnnotation)!
    }
    func buttonPressed(button:UIButton){
        print("")
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let annotation = view.annotation as? CustomPointAnnotation {
                self.performSegueWithIdentifier("CityViewController", sender: annotation)
                print("hotelarray:\(hotelArray)")
                
            }
        
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CityViewController" {
            let destinationViewController = segue.destinationViewController as! CityViewController
            destinationViewController.place = selectdAnnotation.place
            destinationViewController.hotel = hotelArray
        }
        if segue.identifier == "ShowSearchTableView"{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let searchtableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SearchTableViewController") as! SearchTableViewController
            searchtableViewController.hotel = hotelArray
            print("12345\(searchtableViewController.hotel)")
            print("5432\(hotelArray)")
        }
    }
    // MARK: - SearchTableView
    @IBAction func presentSearchTableView(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowSearchTableView", sender: searchButton)
        

        // 用presen的方法到下個controller
//        let searchBarTableViewController = storyboard?.instantiateViewControllerWithIdentifier("SearchBarTableViewController") as! SearchBarTableViewController
//        presentViewController(searchBarTableViewController, animated: true, completion: nil)
    }

    @IBAction func tapInfoView(sender: AnyObject) {
        self.performSegueWithIdentifier("CityViewController", sender: nil)
        
    }
    @IBAction func tapMapView(sender: AnyObject) {
        self.infoView.hidden = true
        
    }
    

}
class Hotel{
    var name: String?
    var latitude: String?
    var longtitude: String?
}
