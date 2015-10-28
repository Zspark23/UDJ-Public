//
//  PlaylistViewController.swift
//  YouDJ
//
//  Created by Jordan Nelson on 9/13/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//
import UIKit
import Firebase
class PlaylistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var playlist: Playlist?
    var song : Song?
    var currentSong: Song?
    @IBOutlet var songTableView: UITableView!
    @IBOutlet weak var playButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkController.sharedInstance.currentPlaylist = playlist
        
        if let currentSong = self.currentSong {
            PlaylistController.sharedInstance.updateSpotifyQueueWithSong(self.currentSong!, playlist: self.playlist!)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        PlaylistController.sharedInstance.loadcurrentSongInPlaylist(playlist!) { (currentSong) -> () in
            self.currentSong = currentSong
            self.songTableView.reloadData()
        }
        PlaylistController.sharedInstance.loadAllSongsInPlaylist(playlist!) { () -> () in
            self.songTableView.reloadData()
        }
    }
    
    // MARK: - Segues
    @IBAction func unwindToThisVC(segue: UIStoryboardSegue, sender:AnyObject) {
        if let vc = segue.sourceViewController as? AddSongViewController{
            self.song = vc.song
            if self.currentSong == nil && PlaylistController.sharedInstance.allSongs.count == 0 {
                PlaylistController.sharedInstance.currentSongForNewPlaylist(self.song!, playlist: self.playlist!)
            } else {
                PlaylistController.sharedInstance.addSongToPlaylist(self.song!, playlist: self.playlist!)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playlistToHistoryAndUsersSegue" {
            let infoVC = segue.destinationViewController as! PlaylistInfoViewController
            infoVC.playlist = self.playlist
        }
    }
    
    // MARK: - DataSource Methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("currentSongCell") as? CurrentSongTableViewCell
            if let currentSong = self.currentSong {
                cell?.configureCellWithSong(currentSong, playlist: self.playlist!)
            }
            return cell!
            
        } else if indexPath.section == 1 && PlaylistController.sharedInstance.allSongs.count >= 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("nextSongCell") as? NextSongsTableViewCell
            let song = PlaylistController.sharedInstance.allSongs[indexPath.row]
            cell?.configureCellWithSong(song)
            
            return cell!
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && self.currentSong != nil {
            return 1
        } else {
            // songs in que count
            return PlaylistController.sharedInstance.allSongs.count
        }
    }
    
    // MARK: - Delegate Methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 130
        } else {
            return 64
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section != 0 {
            return CGFloat(50)
        } else {
            return CGFloat(0)
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let headerCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! HeaderPlaylistCell
            return headerCell.contentView
        } else {
            return nil
        }
    }
    
    // MARK: - Call animation for UITableViewRowAction
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let song = PlaylistController.sharedInstance.allSongs[indexPath.row]
        let upVoteAction = UITableViewRowAction.init(style: .Default, title: "Up Vote") { (rowAction, index) -> Void in
            // Action for up vote
            if (indexPath.row <= PlaylistController.sharedInstance.allSongs.count - 1) {
                song.voteCount = NSNumber(int: (song.voteCount.intValue + 1))
                song.ref?.updateChildValues(["voteCount": song.voteCount])
            }
            
            if (song.voteCount.intValue <= -3) {
                song.ref?.removeValue()
            }
            PlaylistController.sharedInstance.updateSpotifyQueueWithSong(self.currentSong!, playlist: self.playlist!)
        }
        upVoteAction.backgroundColor = UIColor(red: 47.0/255.0, green: 167.0/255.0, blue: 171.0/255.0, alpha: 1.0)
        
        let downVoteAction = UITableViewRowAction.init(style: .Default, title: "Down Vote") { (rowAction, index) -> Void in
            // Action for down vote
            if (indexPath.row <= PlaylistController.sharedInstance.allSongs.count - 1) {
                song.voteCount = NSNumber(int: (song.voteCount.intValue - 1))
                song.ref?.updateChildValues(["voteCount": song.voteCount])
            }
            
            if (song.voteCount.intValue <= -3) {
                song.ref?.removeValue()
            }
            PlaylistController.sharedInstance.updateSpotifyQueueWithSong(self.currentSong!, playlist: self.playlist!)
        }
        downVoteAction.backgroundColor = UIColor(red: 251.0/255.0, green: 65.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        
        let voteCount = UITableViewRowAction.init(style: .Default, title: "\(song.voteCount)") { (rowAction, index) -> Void in
            // Action for delete vote
        }
        voteCount.backgroundColor = UIColor.blackColor()
        
        if indexPath.section == 1 {
            return [upVoteAction, downVoteAction]
        } else {
            return nil
        }
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
        
    }
    
    // MARK: - Play, Pause, Prev, Next Buttons
    @IBAction func playCurrentSong(sender: AnyObject) {
        if let trackPlayer = NetworkController.sharedInstance.player {
            if trackPlayer.isPlaying == true {
                self.playButton.image = UIImage(named: "Play")
                trackPlayer.setIsPlaying(false, callback: nil)
            } else {
                self.playButton.image = UIImage(named: "Pause")
                if Int(trackPlayer.currentPlaybackPosition)
                    == 0 {
                        NetworkController.sharedInstance.playSpotifySongWithID((self.currentSong?.songID)!)
                } else {
                    trackPlayer.setIsPlaying(true, callback: nil)
                }
            }
        }
    }
    @IBAction func prevButtonTapped(sender: UIBarButtonItem) {
        NetworkController.sharedInstance.repeatSpotifySongWithID(self.currentSong!
            .songID)
    }
    
    @IBAction func nextButtonTapped(sender: UIBarButtonItem) {
    }
    
    func updateSpotifyQueueWithSong(song: Song, playlist: Playlist) {
        if let trackPlayer = NetworkController.sharedInstance.player {
            PlaylistController.sharedInstance.loadAllSongsInPlaylist(self.playlist!) { () -> () in
                var queue: [NSURL] = []
                if let currentSong = self.currentSong {
                    queue.append(NSURL(string: "spotify:track:\(currentSong.songID)")!)
                }
                for song in PlaylistController.sharedInstance.allSongs {
                    queue.append(NSURL(string: "spotify:track:\(song.songID)")!)
                }
                trackPlayer.queueURIs(queue, clearQueue: true, callback: nil)
            }
        }
        
    }
}
