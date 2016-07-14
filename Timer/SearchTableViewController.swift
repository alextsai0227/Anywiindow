//
//  SearchTableViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/12.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    // MARK: - Property
    @IBOutlet weak var segment: UISegmentedControl!
    var selectedPlace = Place?()
    var filteredPlaces = [Place]()
    var hotel = [Hotel]()
    let searchController = UISearchController(searchResultsController: nil)
    let searchTableViewCellIdentifier = "SearchTableViewCell"
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.hidden = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = true
        tableView.tableHeaderView = searchController.searchBar
        self.tableView.registerNib(UINib(nibName: searchTableViewCellIdentifier,bundle: nil), forCellReuseIdentifier: searchTableViewCellIdentifier)
        
    }
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.backItem?.hidesBackButton = true
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            selectedPlace = filteredPlaces[indexPath.row]
        
        }else{
            selectedPlace = Place.places[indexPath.row]
        }
        
        
        let cityViewController = storyboard?.instantiateViewControllerWithIdentifier("CityViewController") as! CityViewController
        cityViewController.place = selectedPlace
        cityViewController.hotel = hotel
        presentViewController(cityViewController, animated: true, completion: nil)
    }
    @IBAction func toMapView(sender: AnyObject) {
//        let mapViewController = storyboard?.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
//        presentViewController(mapViewController, animated: true, completion: nil)
        self.performSegueWithIdentifier("MapViewController", sender: nil)

        
    }

    
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        if segue.identifier == "GoToViewController" {
    //            let destinationViewController = segue.destinationViewController as! ViewController
    //            print("hahahahahahaha")
    ////            let place = sender as? Place
    //            destinationViewController.image = selectedPlace!.image
    //
    //
    //
    //        }
    //    }

    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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