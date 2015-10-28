//
//  NetworkController.swift
//  YouDJ
//
//  Created by Jordan Nelson on 9/13/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit
import Firebase


// Base URL https://api.spotify.com/

class NetworkController: NSObject, SPTAudioStreamingPlaybackDelegate {
    
    static let sharedInstance = NetworkController()
    var allUsers: [User] = []
    var searchResultsArray:[Song] = []
    var currentPlaylist: Playlist?
    
    // Spotify Properties
    let spotifyAuthenticator = SPTAuth.defaultInstance()
    var player: SPTAudioStreamingController?
    var playOptions = SPTPlayOptions()
    
    func spotifySearchURL() -> String {
        return "https://api.spotify.com/v1/search"
    }
    
    func loadSongFromSearchTerm(searchString: String, completion: (success: Bool) -> ()) {
        //TODO: Fix this search bug(albums without album art crash the app)
        let urlString = spotifySearchURL().stringByAppendingString("?type=track&market=US&q=\(searchString)")
        let urlPath = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = NSURL(string: urlPath!)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            do {
                let jsonResults = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
                if let jsonTracks = jsonResults["tracks"] {
                    
                    let jSongArray = jsonTracks["items"] as! [AnyObject]
                    
                    var temporaryResults: [Song] = []
                    for (var i=0; i < jSongArray.count; i++) {
                        temporaryResults.append(Song(dictionary: jSongArray[i] as! [String : AnyObject]))
                    }
                    self.searchResultsArray = temporaryResults
                    print(self.searchResultsArray)
                    completion(success: true)
                }
            } catch {
                print("json error: \(error)")
                completion(success: false)
            }
        }
        task.resume()
    }
    
    func loadUserFromSearchTerm(searchString: String, completion: () -> ()) {
        
        let ref = Firebase(url: "https://youdj.firebaseio.com/")
        let userRef = ref.childByAppendingPath("users")
//        let 
        userRef.observeEventType(FEventType.Value, withBlock: { snapshot in
            var allUsersArrray = [User]()
            for item in snapshot.children {
               allUsersArrray.append(User(snapshot: item as! FDataSnapshot))
            }
            self.allUsers = allUsersArrray
            completion()
            }, withCancelBlock: { (error) in
                print(error.localizedDescription)
        })
        
    }
    
    // MARK: Login 
    
    func setupSpotifyPlayer(session: SPTSession!, completion:(success:Bool) -> ()){
        player = SPTAudioStreamingController(clientId: spotifyAuthenticator.clientID)
        player!.playbackDelegate = self
        
        player!.diskCache = SPTDiskCache(capacity: 1024 * 1024 * 64)
       
        player!.loginWithSession(session, callback: { (error: NSError!) in
            if error != nil {
                print("Couldn't login with session: \(error)")
                completion(success: false)
            } else {
                completion(success: true)
            }
        })
    }
    
    func addSongToQueueWithID(songID: String) {
        let spotifyURI = "spotify:track:\(songID)"
        
        if let localPlayer = player {
            //localPlayer.q
        }
    }
    
    func playSpotifySongWithID(songID: String) {
        let spotifyURI = "spotify:track:\(songID)"
        
        if let localPlayer = player {
            localPlayer.playURIs([NSURL(string: spotifyURI)!], withOptions: playOptions, callback: nil)
        } else {
//            self.setupSpotifyPlayer(sessio, completion: <#T##(success: Bool) -> ()#>)
            // set up and play
        }
    }
    
    func repeatSpotifySongWithID(songID: String) {
        let spotifyURI = "spotify:track:\(songID)"
        
        if let localPlayer = player {
            localPlayer.playURIs([NSURL(string: spotifyURI)!], withOptions: nil, callback: nil)
        } else {
            //            self.setupSpotifyPlayer(sessio, completion: <#T##(success: Bool) -> ()#>)
            // set up and play
        }
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: NSURL!) {
        if Int((NetworkController.sharedInstance.player?.currentPlaybackPosition)!) == 0 {
        PlaylistController.sharedInstance.loadAllSongsInPlaylist(self.currentPlaylist!) { () -> () in

        }
            PlaylistController.sharedInstance.updateSpotifyQueueWithSong(PlaylistController.sharedInstance.allSongs[0], playlist: self.currentPlaylist!)
            PlaylistController.sharedInstance.setCurrentSong(PlaylistController.sharedInstance.allSongs[0], playlist: self.currentPlaylist!)
        }
    }
}

/*
class NetworkController: NSObject {
func loadCongress(completion: ((AnyObject) -> Void)!){

var urlString = "https://www.govtrack.us/api/v2/role?current=true"
let url = NSURL(string: urlString)
var dataString:String = ""
let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
//I want to replace this line below with something to save it to a string.
dataString = String(NSString(data: data, encoding: NSUTF8StringEncoding)!)


println(dataString)
}
task.resume()
}
*/