//
//  AddSongViewController.swift
//  YouDJ
//
//  Created by Jordan Nelson on 9/14/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit

class AddSongViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var song : Song!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.searchBar.showsCancelButton = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
}

extension AddSongViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        print(self.searchBar.text!)
        
        
        NetworkController.sharedInstance.loadSongFromSearchTerm(self.searchBar.text!) { (success) -> () in
            
            if success {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    
}



extension AddSongViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkController.sharedInstance.searchResultsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("songSearchCell", forIndexPath: indexPath) as? SongSearchTableViewCell
        
        if indexPath.row < NetworkController.sharedInstance.searchResultsArray.count {
            
            let song = NetworkController.sharedInstance.searchResultsArray[indexPath.row]
            cell?.configureCellWithSong(song)
            
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SongSearchTableViewCell
        
        self.song = cell.song
        
        self.performSegueWithIdentifier("songAddedUnwind", sender: nil)
        
        
    }
    
//    @IBAction func unwindToThisVC(segue: UIStoryboardSegue) {
//        let viewController = segue.destinationViewController as! PlaylistViewController
//        viewController.song = self.song
//   
//    }
//    
//    @IBAction override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//     
//        if segue.identifier == "addSongSegue"{
//          
//        }
//    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
        if unwindSegue.identifier == "addSongSegue"{
            let viewController = unwindSegue.destinationViewController as! PlaylistViewController
            viewController.song = self.song
        }
    }
    
}



