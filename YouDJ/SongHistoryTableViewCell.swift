//
//  SongHistoryTableViewCell.swift
//  YouDJ
//
//  Created by Nathan on 9/24/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit

class SongHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellWithSong(song: Song) {
        
        trackNameLabel.text = ""
        artistNameLabel.text = ""
        albumImageView.image = UIImage()
        
        trackNameLabel.text = song.title
        artistNameLabel.text = song.artist
        self.fetchImageAtURL(NSURL(string: song.albumArtSmall)!) { (image) -> () in
            self.albumImageView.image = image
        }
    }
    
    func fetchImageAtURL(url: NSURL, completion: (image: UIImage) -> ()) {
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            let image = UIImage(data: data!)
            
            completion(image: image!)
            
            }.resume()
    }
}
