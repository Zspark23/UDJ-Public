//
//  HomeTableViewCell.swift
//  YouDJ
//
//  Created by Jordan Nelson on 9/14/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var songCountLabel: UILabel!
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var playlistDescriptionLabel: UILabel!
    @IBOutlet weak var playlistImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCellWithPlaylist(playlist: Playlist) {
        
        playlistNameLabel.text = ""
        playlistDescriptionLabel.text = ""
        playlistImageView.image = UIImage()
        
        playlistNameLabel.text = playlist.title
        playlistDescriptionLabel.text = playlist.playlistDescription
        PlaylistController.sharedInstance.loadAllSongsInPlaylist(playlist, completionClosure: { () -> () in
            self.songCountLabel.text = "\(PlaylistController.sharedInstance.allSongs.count) songs"
        })
        
        PlaylistController.sharedInstance.loadAllPlaylists { () -> () in
            PlaylistController.sharedInstance.allSongs
        }
    }
    
    func configureCellWithSongAndPlaylist(song: Song, playlist: Playlist) {
        
        playlistNameLabel.text = ""
        playlistDescriptionLabel.text = ""
        playlistImageView.image = UIImage()
        
        playlistNameLabel.text = playlist.title
        playlistDescriptionLabel.text = playlist.playlistDescription
        PlaylistController.sharedInstance.loadAllSongsInPlaylist(playlist, completionClosure: { () -> () in
            self.songCountLabel.text = "\(PlaylistController.sharedInstance.allSongs.count + 1) songs"
        })
        
        PlaylistController.sharedInstance.loadAllPlaylists { () -> () in
            PlaylistController.sharedInstance.allSongs
        }
        
        self.fetchImageAtURL(NSURL(string: song.albumArtLarge)!) { (image) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.playlistImageView.image = image
            })
        }

    }
    
    func fetchImageAtURL(url: NSURL, completion: (image: UIImage) -> ()) {
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            let image = UIImage(data: data!)
            
            completion(image: image!)
            
            }.resume()
    }
}
