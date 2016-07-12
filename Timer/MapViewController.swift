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

class MapViewController: UIViewController,MKMapViewDelegate{

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var places = [["name":"Brisbane", "lat":"-27.3810177", "long":"152.4313083","image":"Brisbane","image2":"Brisbane2"], ["name":"Osaka", "lat":"34.678395", "long":"135.4600445","image":"Osaka","image2":"Osaka2"],["name":"SanFrancisco", "lat":"37.7576792", "long":"-122.5078124","image":"SanFrancisco","image2":"SanFrancisco2"],["name":"Taipei", "lat":"25.08534", "long":"121.4228168","image":"Taipei","image2":"Taipei2"],["name":"ShanHai", "lat":"31.2231276", "long":"120.9148739","image":"ShanHai","image2":"ShanHai2"],["name":"Hokkaido", "lat":"43.4349557", "long":"140.5423807","image":"Hokkaido","image2":"Hokkaido2"],["name":"Boracay", "lat":"11.973899", "long":"121.9052984","image":"Boracay","image2":"Boracay2"],["name":"Hawaii", "lat":"21.410097", "long":"157.970329","image":"Hawaii","image2":"Hawaii2"]]
    var tryplace: [[String : Any]] = [["name":"Brisbane", "lat":"-27.3810177", "long":"152.4313083","image":[UIImage(named:"Taipei"),UIImage(named:"Taipei2")]], ["name":"Osaka", "lat":"34.678395", "long":"135.4600445"]]
    class CustomPointAnnotation: MKPointAnnotation {
        var imageName: String!
        var image: String!
        var image2: String!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        for trydata in tryplace{
            print("121321:\(trydata["name"])")
            

        }
        
        
        for data in Place.places {
            let annotation = CustomPointAnnotation()
            annotation.title = data.name
            annotation.coordinate = CLLocationCoordinate2DMake(Double(data.latitude)!, Double(data.longitude)!)
            annotation.imageName = data.name
            annotation.image = data.image
            annotation.image2 = data.image2

            self.mapView.addAnnotation(annotation)
        }

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
        annotationView?.image = UIImage().imageWithImage(UIImage(named: annotation.title!!)!, scaledToSize: CGSizeMake(44, 44)).circle
        //讀入圖片，設定成Callout左邊顯示的View
        let starImageView = UIImageView(image: UIImage(named: "Star"))
        annotationView?.leftCalloutAccessoryView = starImageView
        
        //Callout的右邊，設定成按鈕
        let button = UIButton(type: .DetailDisclosure)
        button.addTarget(self, action: #selector(MapViewController.buttonPressed(_:)), forControlEvents: .TouchUpInside)
        annotationView?.rightCalloutAccessoryView = button
//        annotationView?.layer.cornerRadius = (annotationView?.frame.size.width)!/2
        
        //回傳大頭針
        return annotationView
    }
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("just pressed button")
//        self.performSegueWithIdentifier("ViewController", sender: nil)
    }
    func buttonPressed(button:UIButton){
        print("")
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let annotation = view.annotation as? CustomPointAnnotation {
                self.performSegueWithIdentifier("ViewController", sender: annotation)
                print("annotation.imageName = \(annotation.imageName)")
            }
        
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewController" {
            let destinationViewController = segue.destinationViewController as! CityViewController
            let place = sender as? CustomPointAnnotation
            destinationViewController.imageName = place!.imageName
            destinationViewController.image = place!.image
            destinationViewController.image2 = place!.image2
            
        }
    }
    // MARK: - SearchTableView
    @IBAction func presentSearchTableView(sender: AnyObject) {
//        let searchBarTableViewController = storyboard?.instantiateViewControllerWithIdentifier("SearchBarTableViewController") as! SearchBarTableViewController        
//        presentViewController(searchBarTableViewController, animated: true, completion: nil)
        self.performSegueWithIdentifier("ShowSearchTableView", sender: searchButton)
    
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
