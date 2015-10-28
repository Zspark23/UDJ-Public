//
//  PlaylistInfoViewController.swift
//  YouDJ
//
//  Created by Nathan on 9/24/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit

class PlaylistInfoViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var song: Song?
    var playlist: Playlist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlaylistController.sharedInstance.loadAllSongsInPlaylist(playlist!) { () -> () in
            self.tableView.reloadData()
        }

        NetworkController.sharedInstance.loadUserFromSearchTerm("") { () -> () in
            self.tableView.reloadData()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControlTapped(sender: UISegmentedControl) {
        self.tableView.reloadData()
        
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

extension PlaylistInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return PlaylistController.sharedInstance.allSongs.count
        } else {
            return NetworkController.sharedInstance.allUsers.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("songHistoryCell", forIndexPath: indexPath) as? SongHistoryTableViewCell
            if PlaylistController.sharedInstance.playlistHistory.count > 0 {
                
                song = PlaylistController.sharedInstance.playlistHistory[indexPath.row]
                if let localSong = song {
                    cell?.artistNameLabel.text = "\(localSong.artist) - \(localSong.album)"
                    cell?.trackNameLabel.text = localSong.title
                    cell?.albumImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: localSong.albumArtSmall)!)!)
                }
              
            }
            return cell!
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("playlistUserCell", forIndexPath: indexPath) as? PlaylistUserTableViewCell
           
            let user = NetworkController.sharedInstance.allUsers[indexPath.row]
            
            cell?.usernameLabel.text = user.name
            
            return cell!
        }

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 64
        } else {
            return 44
        }
    }
}






