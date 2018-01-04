//
//  BaseAPI.swift
//  Stax
//
//  Created by icbrahimc on 12/25/17.
//  Copyright © 2017 icbrahimc. All rights reserved.
//

import FirebaseCore
import FirebaseFirestore
import UIKit

class BaseAPI: NSObject {
    static let sharedInstance = BaseAPI()
    var db: Firestore!
    
    override private init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    /////////////////* Adding to Database */////////////////
    
    /* add a playlist to the database */
    func addPlaylist(playlist: Playlist) {
        let user = getUserGivenUsername(username: playlist.creatorUsername)

        let playlistReference = db.collection("playlists").addDocument(data: [
            "name": playlist.name!,
            "rating": playlist.rating.doubleValue,
            "favorites": playlist.numFavorites.doubleValue,
            "num_ratings": playlist.numRatings.intValue,
            "apple_link": playlist.appleLink!,
            "cloud_link": playlist.cloudLink!,
            "spotify_link": playlist.spotifyLink!,
            "cover_art_link": playlist.coverArtLink!,
            "tags": playlist.tags! as NSArray as! [String],
            "creator": user
        ]) { (error: Error?) in
            if let error = error {
                print("Error adding playlist: \(error)")
            } else {
                print("Playlist, \(playlist.name!), added successfully")
            }
        }
        //TODO: add a reference from this playlist to the playlist creator's created playlists list
        
    }
    
    /* Add a user to the database */
    func addUser(user: User) {
        db.collection("users").document(user.username!).setData([
            "name": user.name!,
            "id": user.id!.doubleValue
        ]) { (error: Error?) in
            if let error = error {
                print("Error adding user: \(error)")
            } else {
                print("User, \(user.username!), added successfully")
            }
        }
    }
    
    /////////////////* Updating in Database *///////////////////
    
    //TODO: add in enums so that there is just one update function that takes in as a paramater the playlist, what to update (ex. rating, favorites, name, links), and what to update to and have switch cases for each of those options
    
    /* Update a playlist rating */
    func updatePlaylistRating(playlist: Playlist) {
        db.collection("playlists").document(playlist.id!).updateData(
            [
                "num_ratings": playlist.numRatings.doubleValue,
                "rating": playlist.rating.doubleValue,
            ]
        ) { (error: Error?) in
            if let error = error {
                print("Error updating playlist rating: \(error)")
            } else {
                print("Playlist, \(playlist.name!) rating successfully updated to \(playlist.rating.doubleValue)")
            }
        }
    }
    
    /* Increment number of favorites for a playlist */
    func updatePlaylistFavorites(playlist: Playlist) {
        db.collection("playlists").document(playlist.id!).updateData(
            ["favorites": playlist.numFavorites.doubleValue]
        ) { (error: Error?) in
            if let error = error {
                print("Error updating playlist favorites: \(error)")
            } else {
                print("Playlist, \(playlist.name!) num favorites successfully updated to \(playlist.numFavorites.doubleValue)")
            }
        }
    }
    
    /* Update a user's name */
    func updateName(user: User) {
        db.collection("users").document(user.username!).setData(["name": user.name!], options: SetOptions.merge()) { (error: Error?) in
            if let error = error {
                print("Error updating user's name: \(error)")
            } else {
                print("User, \(user.username!), name successfully updated to \(user.name!)")
            }
        }
    }
    
    func tester2(username: String, name: String) {
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "name": name,
        ]) { err in
            if let err = err {
                print("error adding document: \(err)")
            } else {
                print("document added with id: \(ref!.documentID)")
            }
        }
    }
    
    func tester (username: String) {
        db.collection("users").document(username).getDocument { (document, error) in
            if let document = document {
                let favoritedPlaylists = document.data()
                print("Document data: \(favoritedPlaylists)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    /* Favorite a playlist */
    func favoritePlaylist(user: User, playlist: Playlist) {
        let playlistRef = db.collection("playlists").document(playlist.id!);
        db.collection("users").document(user.username!).getDocument { (document, error) in
            if let document = document {
                let favoritedPlaylists = document.data()
                print("Document data: \(favoritedPlaylists)")
            } else {
                print("Document does not exist")
            }
        }
        //TODO: get current favorited playlists, add the playlistRef to that list, then set the favorited playlists to the list with the new one added
    }
    
    /* Unfavorite a playlist */
    func unFavoritePlaylist(user: User, playlist: Playlist) {
        let playlistRef = db.collection("playlists").document(playlist.id!);
        db.collection("users").document(user.username!).getDocument { (document, error) in
            if let document = document {
                let favoritedPlaylists = document.data()
                print("Document data: \(favoritedPlaylists)")
            } else {
                print("Document does not exist")
            }
        }
        //TODO: get current favorited playlists, remove the playlistRef from that list, then set the favorited playlists to the list with the one removed
    }
    
    /* Rate a playlist */
    func ratePlaylist(user: User, playlist: Playlist) {
        //TODO: get all rated playlists, add this playlist to the list, set rated playlists to this list with the new one added
    }
    
    ///////////////* Database Queries *///////////////////////
    
    /* Get the top rated playlists */
    func getTopRatedPlaylists(numPlaylists: Int) -> Query {
        let playlists = db.collection("playlists");
        return playlists.order(by: "rating", descending: true)
    }
    
    /* Get the top favorited playlists */
    func getTopFavoritedPlaylists(numPlaylists: Int) -> Query {
        let playlists = db.collection("playlists");
        return playlists.order(by: "favorites", descending: true)
    }
    
    /* Get all playlists with a certain tag */
    
    /* Get a playlist given it's id */
    func getPlaylistGivenId(id: String?) -> DocumentReference {
        return db.collection("playlists").document(id!) 
    }
    
    /* Get a user given their username */
    func getUserGivenUsername(username: String?) -> DocumentReference {
        return db.collection("users").document(username!)
    }
    
}
