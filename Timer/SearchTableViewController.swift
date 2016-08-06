//
//  SearchTableViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/12.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit
import MapKit

class SearchTableViewController: UITableViewController,CLLocationManagerDelegate {
    // MARK: - Property
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var selectedPlace = Place?()
    var filteredPlaces = [Place]()
    let searchController = UISearchController(searchResultsController: nil)
    let searchTableViewCellIdentifier = "SearchTableViewCell"
    let locationmanerger = CLLocationManager()
    var userLocation = CLLocation()
    var windowdistances = [CustomWindow]()
    var selecteddistance = CustomWindow?()
    class CustomWindow {
        var distance: Double!
        var coordinate: CLLocationCoordinate2D!

        
    }
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        navigationController?.navigationBar.hidden = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false

        tableView.tableHeaderView = searchController.searchBar
        self.tableView.registerNib(UINib(nibName: searchTableViewCellIdentifier,bundle: nil), forCellReuseIdentifier: searchTableViewCellIdentifier)
        //取得使用者位置資訊
        self.locationmanerger.requestWhenInUseAuthorization()
        self.locationmanerger.delegate = self
        self.locationmanerger.requestLocation()
        self.locationmanerger.startUpdatingLocation()
    }
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.backItem?.hidesBackButton = true
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    override func viewDidDisappear(animated: Bool) {
        self.locationmanerger.stopUpdatingLocation()
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - 算使用者和Window距離

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationmanerger.stopUpdatingLocation()
        
        if locations.isEmpty == false {
            userLocation = locations.first!
        }
        for place in Place.places {
            for data in place.window{
                let window = CustomWindow()
                window.coordinate = CLLocationCoordinate2DMake(Double(data.latitude)!, Double(data.longitude)!)
                window.distance = GetDistance_Google(userLocation.coordinate, pointB: window.coordinate)
                windowdistances.append(window)
            }
        }
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
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredPlaces.count
        }
        return Place.places.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(searchTableViewCellIdentifier, forIndexPath: indexPath) as! SearchTableViewCell
        var place: Place = Place.places[indexPath.row]
        if searchController.active && searchController.searchBar.text != "" {
            place = filteredPlaces[indexPath.row]
        } else {
            place = Place.places[indexPath.row]
        }
        cell.cityImageView.image = UIImage(named: place.city)
        cell.cityLabel.text = place.city
        cell.workWindowCount.text = place.country
        return cell
    }
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPlaces = Place.places.filter { place in
//            let categoryMatch = (scope == "All") || (place.category == scope)
            return place.city.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select row")
        if (searchController.active){
            if filteredPlaces.count > 0{
                selectedPlace = filteredPlaces[indexPath.row]
                selecteddistance = windowdistances[indexPath.row]
            }else{
                selectedPlace = Place.places[indexPath.row]
                selecteddistance = windowdistances[indexPath.row]
            }
        }else{
            selectedPlace = Place.places[indexPath.row]
                selecteddistance = windowdistances[indexPath.row]
        }
        
        
        let cityViewController = storyboard?.instantiateViewControllerWithIdentifier("CityViewController") as! CityViewController
        cityViewController.place = selectedPlace
        cityViewController.distance = selecteddistance?.distance
        print(selecteddistance?.distance)
        presentViewController(cityViewController, animated: true, completion: nil)
    }

}
extension SearchTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        
    }
}
extension SearchTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!)
    }
}