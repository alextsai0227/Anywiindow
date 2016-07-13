//
//  SearchCollectionViewController.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/12.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit

class SearchCollectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!    
    @IBOutlet weak var collectionviewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UIView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPlaces = [Place]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let spacingWidth = Float(10)
        let width = (Float(UIScreen.mainScreen().bounds.width) - spacingWidth * Float(2))
        self.collectionviewLayout.itemSize = CGSize(width: CGFloat(width), height: CGFloat(width))

        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["All", "Asia", "America"]
        searchBar = searchController.searchBar
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
        return Place.places.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SearchCollectionViewCell", forIndexPath: indexPath) as! SearchCollectionViewCell
        cell.imageView.image = UIImage(named: Place.places[indexPath.row].name)
        return cell
    }
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPlaces = Place.places.filter { place in
            let categoryMatch = (scope == "All") || (place.category == scope)
            return  categoryMatch && place.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        collectionView.reloadData()
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
extension SearchCollectionViewController: UISearchBarDelegate,UISearchResultsUpdating{
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)    }
}
