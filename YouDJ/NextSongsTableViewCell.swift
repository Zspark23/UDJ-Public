//
//  NextSongsTableViewCell.swift
//  YouDJ
//
//  Created by Jordan Nelson on 9/14/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit

class NextSongsTableViewCell: UITableViewCell {

    @IBOutlet weak var artistLabel: UILabel!
//    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var upVoteArrow: UIButton!
    @IBOutlet weak var downVoteArrow: UIButton!
    @IBOutlet weak var voteCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellWithSong(song: Song) {
        
        artistLabel.text = ""
        trackNameLabel.text = ""
        songImage.image = UIImage()
        
        artistLabel.text = "\(song.artist) - \(song.album)"
        trackNameLabel.text = song.title

        voteCountLabel.text = "\(song.voteCount)"
        
        if song.voteCount == 0 {
            upVoteArrow.hidden = false
            downVoteArrow.hidden = false
            voteCountLabel.textColor = UIColor.blackColor()
        } else if song.voteCount.intValue < 0 {
            upVoteArrow.hidden = true
            downVoteArrow.hidden = false
            voteCountLabel.textColor = UIColor.blackColor()
        } else if song.voteCount.intValue > 0 {
            upVoteArrow.hidden = false
            downVoteArrow.hidden = true
        }
        
        self.fetchImageAtURL(NSURL(string: song.albumArtSmall)!) { (image) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.songImage.image = image
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
