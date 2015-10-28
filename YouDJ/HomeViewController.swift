//
//  HomeViewController.swift
//  YouDJ
//
//  Created by Jordan Nelson on 9/13/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var playlistTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        PlaylistController.sharedInstance.loadAllPlaylists { () -> () in
            self.playlistTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaylistController.sharedInstance.allPlaylists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homeCell", forIndexPath: indexPath) as? HomeTableViewCell
        
        
        
        PlaylistController.sharedInstance.loadcurrentSongInPlaylist(PlaylistController.sharedInstance.allPlaylists[indexPath.row]) { (currentSong) -> () in
            cell?.configureCellWithSongAndPlaylist(currentSong, playlist: PlaylistController.sharedInstance.allPlaylists[indexPath.row])
            
            
        }
        
        cell?.configureCellWithPlaylist(PlaylistController.sharedInstance.allPlaylists[indexPath.row])
        
        return cell!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let playlist = PlaylistController.sharedInstance.allPlaylists[indexPath.row]
            playlist.ref?.removeValue()
        }
    }
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewPlaylist" {
            let playlistVC = segue.destinationViewController as! PlaylistViewController
            let indexPath: NSIndexPath! = playlistTableView.indexPathForSelectedRow
            let playlist: Playlist = PlaylistController.sharedInstance.allPlaylists[indexPath.row]
            playlistVC.title = playlist.title
            playlistVC.playlist = playlist
        }
    }
    
}
