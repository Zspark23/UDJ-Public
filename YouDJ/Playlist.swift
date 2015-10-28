//
//  Playlist.swift
//  YouDJ
//
//  Created by Zack Spicer on 9/15/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit
import Firebase

class Playlist: NSObject {

    let title: String
    let playlistDescription: String
    let ref: Firebase?
    
    init(title: String, playlistDescription: String) {
        
        self.title = title
        self.playlistDescription = playlistDescription
        self.ref = nil
    }
    
    init(snapshot: FDataSnapshot) {
        title = snapshot.value["title"] as! String
        playlistDescription = snapshot.value["description"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "title": title,
            "description": playlistDescription
        ]
    }
}