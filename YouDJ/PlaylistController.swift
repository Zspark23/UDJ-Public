//
//  PlaylistController.swift
//  YouDJ
//
//  Created by Zack Spicer on 9/15/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit
import Firebase



class PlaylistController: NSObject {
    
    static let sharedInstance = PlaylistController()
    var allPlaylists: [Playlist] = []
    var allSongs: [Song] = []
    var playlistHistory: [Song] = []
    var membersInPlaylist: [User] = []
    let rootRef = Firebase(url: "https://youdj.firebaseio.com/")
    var currentSongArray: [Song] = []
    
    
    func createPlaylistWithTitle(title: String, description: String) {
        let allPlaylistsRef = rootRef.childByAppendingPath("playlists")
        let specificPlaylistRef = allPlaylistsRef.childByAutoId()
        let playlist = Playlist(title: title, playlistDescription: description)
        specificPlaylistRef.setValue(playlist.toAnyObject())
    }

    func addSongToPlaylist(song: Song, playlist: Playlist) {
        let allSongsRef = playlist.ref?.childByAppendingPath("queue")
        let specificSongRef = allSongsRef?.childByAppendingPath("\(song.songID)")
        specificSongRef?.setValue(song.toAnyObject())
    }
    
//    func addUserToPlaylist(user: User, playlist: Playlist){
//        let specificMemberRef = playlist.ref?.childByAppendingPath("members").childByAppendingPath("\(user.uid)")
//        specificMemberRef!.setValue(user.toAnyObject())
//    }
    func addUserToPlaylistMembers(user: User) {
        membersInPlaylist.append(user)
    }
    
    func setCurrentSong(song: Song, playlist: Playlist) {
        let allSongsRef = playlist.ref?.childByAppendingPath("queue")
        let specificSongRef = allSongsRef?.childByAppendingPath(song.songID)
        specificSongRef?.removeValue()
      
        // set current song value
        let currentSongRef = playlist.ref?.childByAppendingPath("currentSong")
        
        currentSongRef?.setValue(song.toAnyObject())
        self.addSongToHistory(song, playlist: playlist)
    }
    
    func currentSongForNewPlaylist(song: Song, playlist: Playlist){
        let currentSongRef = playlist.ref?.childByAppendingPath("currentSong")
        currentSongRef?.setValue(song.toAnyObject())
    }
    
    func addSongToHistory(song: Song, playlist: Playlist){
        let historyRef = playlist.ref?.childByAppendingPath("history")
        historyRef?.setValue(song.toAnyObject())
    }
    
    func loadUsersInPlaylist(playlist: Playlist, completionClosure: () -> ()) {
        let membersRef = playlist.ref?.childByAppendingPath("members")
        membersRef?.observeEventType(.Value, withBlock: { (snapshot) -> Void in
            var tempMembersArray = [User]()
            for item in snapshot.children {
                tempMembersArray.append(User(snapshot: item as! FDataSnapshot))
            }
            self.membersInPlaylist = tempMembersArray
            completionClosure()
            }, withCancelBlock: { (error) -> Void in
                print(error.localizedDescription)
        })
    }
    
    func loadAllPlaylists(completionClosure: () -> ()) {
        let playlistRef = rootRef.childByAppendingPath("playlists")
        playlistRef.observeEventType(FEventType.Value, withBlock: { snapshot in
            var allPlaylistsArray = [Playlist]()
            for item in snapshot.children {
                allPlaylistsArray.append(Playlist(snapshot: item as! FDataSnapshot))
            }
            self.allPlaylists = allPlaylistsArray
            completionClosure()
            }, withCancelBlock: { (error) in
                print(error.localizedDescription)
        })
    }
    
    func loadAllSongsInPlaylist(playlist: Playlist, completionClosure: () -> ()) {
        let songsRef = playlist.ref?.childByAppendingPath("queue")
        songsRef!.observeEventType(FEventType.Value, withBlock: { snapshot in
            var allSongsArray = [Song]()
            for item in snapshot.children {
                allSongsArray.append(Song(snapshot: item as! FDataSnapshot))
            }
            allSongsArray.sortInPlace({$0.voteCount.intValue > $1.voteCount.intValue})
            self.allSongs = allSongsArray
            completionClosure()
            }) { (error) -> Void in
                print(error.localizedDescription)
        }
        completionClosure()
    }
    
    func loadcurrentSongInPlaylist(playlist: Playlist, completion:(currentSong:Song) -> ()) {
        let songsRef = playlist.ref?.childByAppendingPath("currentSong")
        songsRef?.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.value as? NSNull == nil {
                songsRef!.observeEventType(FEventType.Value, withBlock: { snapshot in
                    var tempCurrentSong: [Song] = []
                    tempCurrentSong.append(Song(snapshot: snapshot))
                    
                    self.currentSongArray = tempCurrentSong
                    completion(currentSong: self.currentSongArray.first!)
                    }) { (error) -> Void in
                        print(error.localizedDescription)
                }
            }
        })
    }
    
    func updateSpotifyQueueWithSong(currentSong: Song, playlist: Playlist) {
        PlaylistController.sharedInstance.loadAllSongsInPlaylist(playlist) { () -> () in
            var queue: [NSURL] = []
            
            for song in PlaylistController.sharedInstance.allSongs {
                queue.append(NSURL(string: "spotify:track:\(song.songID)")!)
            }
            
            NetworkController.sharedInstance.player?.queueURIs(queue, clearQueue: true, callback: nil)
        }
        
    }

    
}
