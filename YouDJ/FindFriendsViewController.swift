//
//  FindFriendsViewController.swift
//  YouDJ
//
//  Created by Soren Nelson on 9/23/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit

class FindFriendsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}

extension FindFriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! UserSearchTableViewCell
        
        let user = NetworkController.sharedInstance.allUsers[indexPath.row]
        cell.configureCellWithUser(user)
        
        //        let song = NetworkController.sharedInstance.searchResultsArray[indexPath.row]
        //        cell?.configureCellWithSong(song)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkController.sharedInstance.allUsers.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        PlaylistController.sharedInstance.addUserToPlaylistMembers(NetworkController.sharedInstance.allUsers[indexPath.row])
    }
}

extension FindFriendsViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        NetworkController.sharedInstance.loadUserFromSearchTerm(self.searchBar.text!) { () -> () in
            self.tableView.reloadData()
        }
    }
}
