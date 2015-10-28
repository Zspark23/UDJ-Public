//
//  Song.swift
//  YouDJ
//
//  Created by Jordan Nelson on 9/14/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import Foundation
import Firebase

class Song: NSObject {
    
    let title: String
    let artist: String
    let album: String
    let albumArtSmall: String
    let albumArtLarge: String
    var songID: String
    var voteCount: NSNumber
    let songDuration: NSNumber
    let ref: Firebase?
    
    init(title: String, artist: String, album: String, albumArtSmall: String, albumArtLarge: String, voteCount: NSNumber , songDuration: NSNumber, songID: String) {
        
        self.title = title
        self.artist = artist
        self.songID = songID
        self.album = album
        self.albumArtSmall = albumArtSmall
        self.albumArtLarge = albumArtLarge
        self.voteCount = voteCount
        self.songDuration = songDuration
        self.ref = nil
    }
    
    // Spotify Initializer
    init(dictionary: [String: AnyObject]) {
        self.title = dictionary["name"] as! String
        let artistArray = dictionary["artists"] as! [AnyObject]
        let tempArtist = artistArray.first as! [String: AnyObject]
        self.artist = tempArtist["name"] as! String
        self.songID = dictionary["id"] as! String
        let tempAlbum = dictionary["album"] as! [String: AnyObject]
        self.album = tempAlbum["name"] as! String
        let albumImages = tempAlbum["images"] as! [AnyObject]
        let image640 = albumImages[0] as! [String: AnyObject]
        self.albumArtLarge = image640["url"] as! String
        let image300 = albumImages[1] as! [String: AnyObject]
        self.albumArtSmall = image300["url"] as! String
        self.voteCount = 0
        self.songDuration = dictionary["duration_ms"] as! NSNumber
        self.ref = nil
    }
    
    // Firebase
    init(snapshot: FDataSnapshot) {
        title = snapshot.value["title"] as! String
        artist = snapshot.value["artist"] as! String
        album = snapshot.value["album"] as! String
        albumArtLarge = (snapshot.value["albumArtLarge"] as! String)
        albumArtSmall = (snapshot.value["albumArtSmall"] as! String)
        songID = snapshot.value["songID"] as! String
        voteCount = snapshot.value["voteCount"] as! NSNumber
        songDuration = snapshot.value["duration"] as! NSNumber
        ref = snapshot.ref
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "title": title,
            "artist": artist,
            "album": album,
            "albumArtLarge": albumArtLarge,
            "albumArtSmall": albumArtSmall,
            "songID" : songID,
            "voteCount": voteCount,
            "duration": songDuration
        ]
    }
}