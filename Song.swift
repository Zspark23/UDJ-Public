//
//  Song.swift
//  YouDJ
//
//  Created by Jordan Nelson on 9/14/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit

class Song: NSObject {
    
    let songId: String
    let name: String
//    let artist: String
//    let albumArtURL: NSURL
    
    init(dictionary:Dictionary<String,String>){
        self.songId = dictionary["id"] as String!
        self.name = dictionary["name"] as String!
//        if let artistDictionary = dictionary["artists"] as? [String: String] {
//            self.artist = artistDictionary["name"]!
//        }
        
    }

}
