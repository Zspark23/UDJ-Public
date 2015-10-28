//
//  SongSearchTableViewCell.swift
//  YouDJ
//
//  Created by Nathan on 9/21/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit

class SongSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumArtImageView: UIImageView!
    var song : Song!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCellWithSong(song: Song) {
        
        songTitleLabel.text = ""
        artistLabel.text = ""
        albumArtImageView.image = UIImage()
        
        songTitleLabel.text = song.title
        artistLabel.text = "\(song.artist) - \(song.album)"
        self.song = song
        
        
        fetchImageAtURL(NSURL(string: self.song.albumArtSmall)!, completion: { (image) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.albumArtImageView.image = image
            })
        })
    }
    
    func fetchImageAtURL(url: NSURL, completion: (image: UIImage) -> ()) {
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            let image = UIImage(data: data!)
            
            completion(image: image!)
            
        }.resume()
    }
}
