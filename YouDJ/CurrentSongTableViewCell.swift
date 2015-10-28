//
//  CurrentSongTableViewCell.swift
//  YouDJ
//
//  Created by Jordan Nelson on 9/14/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit

class CurrentSongTableViewCell: UITableViewCell {

    @IBOutlet weak var songProgressView: UIProgressView!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var currentSongImage: UIImageView!
    @IBOutlet weak var songDurationRemainingLabel: UILabel!
    @IBOutlet weak var songDurationPlayedLabel: UILabel!
    @IBOutlet weak var songProgress: UIProgressView!
    var playlist: Playlist?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellWithSong(song: Song, playlist: Playlist) {
        
        if let trackPlayer = NetworkController.sharedInstance.player {
            let durationLeft = Int(trackPlayer.currentTrackDuration) - Int(trackPlayer.currentPlaybackPosition)
            let minutesRemaining = Int(durationLeft / 60)
            let secondsRemaining = Int(durationLeft - (minutesRemaining * 60))
        }
        
        albumLabel.text = ""
        artistLabel.text = ""
        songProgressView.progress = 0
        trackNameLabel.text = ""
        currentSongImage.image = UIImage()
        
        songProgress.progress = 0.0
        songProgress.progressTintColor = UIColor(red: 47.0/255.0, green: 167.0/255.0, blue: 171.0/255.0, alpha: 1.0)
        self.playlist = playlist
        
        albumLabel.text = song.album
        artistLabel.text = song.artist
        trackNameLabel.text = song.title
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "update", userInfo: nil, repeats: true)
        
        self.fetchImageAtURL(NSURL(string: song.albumArtLarge)!) { (image) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.currentSongImage.image = image
            })
        }
    }
    
    func update() {
        if let trackPlayer = NetworkController.sharedInstance.player {
            let minutesPlayed = Int(trackPlayer.currentPlaybackPosition / 60)
            let secondsPlayed = Int(trackPlayer.currentPlaybackPosition) - (minutesPlayed * 60)
            if secondsPlayed >= 10 {
                songDurationPlayedLabel.text = "\(minutesPlayed):\(secondsPlayed)"
            } else if secondsPlayed <= 9 {
                songDurationPlayedLabel.text = "\(minutesPlayed):0\(secondsPlayed)"
            }
            
            let durationLeft = Int(trackPlayer.currentTrackDuration) - Int(trackPlayer.currentPlaybackPosition)
            let minutesRemaining = Int(durationLeft / 60)
            let secondsRemaining = Int(durationLeft - (minutesRemaining * 60))
            if secondsRemaining >= 10 {
                songDurationRemainingLabel.text = "\(minutesRemaining):\(secondsRemaining)"
            } else if secondsRemaining <= 9 {
                songDurationRemainingLabel.text = "\(minutesRemaining):0\(secondsRemaining)"
            }
            songProgress.progress = Float(trackPlayer.currentPlaybackPosition) / Float(trackPlayer.currentTrackDuration)
        }
        
    }
    
    func fetchImageAtURL(url: NSURL, completion: (image: UIImage) -> ()) {
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            let image = UIImage(data: data!)
            
            completion(image: image!)
            
            }.resume()
    }

    
}
