//
//  UserMovie+CoreDataProperties.swift
//  MovieMatrix
//
//  Created by pranay chander on 28/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//
//

import Foundation
import CoreData


extension UserMovie {

    @nonobjc public class func fetchMovieRequest() -> NSFetchRequest<UserMovie> {
        return NSFetchRequest<UserMovie>(entityName: "UserMovie")
    }

    @NSManaged public var adult: Bool
    @NSManaged public var backdropPath: String?
    @NSManaged public var genreIds: [Int64]?
    @NSManaged public var id: Int64
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isWatchlisted: Bool
    @NSManaged public var originalLanguage: String?
    @NSManaged public var originalTitle: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var releaseYear: String?
    @NSManaged public var title: String?
    @NSManaged public var video: Bool
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int64
    @NSManaged public var user: UserProfile?
    
    @nonobjc public class func saveUserMovies(movieJSON: [[String: Any]], user: UserProfile, isFavorites: Bool = false, isWatchlisted: Bool = false) {
        let context = MMPersistentStore.sharedInstance.mainManagedObjectContext
        for movie in movieJSON {
            let movieID = movie["id"] as! Int
            let fetchMovieWithIDRequest = fetchMovieRequest()
            let userPredicate = NSPredicate(format: "user.userId == %d", user.userId)
            let moviePredicate = NSPredicate(format: "id == %d", movieID)
            let sortDiscriptor = NSSortDescriptor(key: "id", ascending: false)
            fetchMovieWithIDRequest.sortDescriptors = [sortDiscriptor]
            fetchMovieWithIDRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [moviePredicate, userPredicate])
            
            var userMovie: UserMovie?
            context.perform {
                do {
                    userMovie = try context.fetch(fetchMovieWithIDRequest).first
                } catch {
                    print(MMErrorStrings.coreDataFetchError)
                }
                if let fetchedMovie = userMovie {
                    fetchedMovie.genreIds = movie["genre_ids"] as? [Int64]
                    fetchedMovie.adult = movie["adult"] as? Bool ?? false
                    if isFavorites {
                      fetchedMovie.isFavorite = isFavorites
                    } else {
                        fetchedMovie.isWatchlisted = isWatchlisted
                    }
                    
                    fetchedMovie.video = movie["video"] as? Bool ?? false
                    fetchedMovie.backdropPath = movie["backdrop_path"] as? String
                    fetchedMovie.originalLanguage = movie["original_language"] as? String
                    fetchedMovie.originalTitle = movie["original_title"] as? String
                    fetchedMovie.overview = movie["overview"] as? String
                    fetchedMovie.posterPath = movie["poster_path"] as? String
                    fetchedMovie.releaseDate = movie["release_date"] as? String
                    fetchedMovie.releaseYear = String(fetchedMovie.releaseDate?.prefix(4) ?? "")
                    fetchedMovie.title = movie["title"] as? String
                    fetchedMovie.popularity = movie["popularity"] as? Double ?? 0.0
                    fetchedMovie.voteCount = movie["voteCount"] as? Int64 ?? 0
                    fetchedMovie.voteAverage = movie["voteAverage"] as? Double ?? 0.0
                    
                    MMPersistentStore.sharedInstance.save(context: context)
                } else {
                    let fetchedMovie = NSEntityDescription.insertNewObject(forEntityName: "UserMovie", into: context) as! UserMovie
                    fetchedMovie.id = movie["id"] as? Int64 ?? 0
                    fetchedMovie.user = user
                    fetchedMovie.genreIds = movie["genre_ids"] as? [Int64]
                    fetchedMovie.adult = movie["adult"] as? Bool ?? false
                    if isFavorites {
                      fetchedMovie.isFavorite = isFavorites
                    } else {
                        fetchedMovie.isWatchlisted = isWatchlisted
                    }
                    
                    fetchedMovie.video = movie["video"] as? Bool ?? false
                    fetchedMovie.backdropPath = movie["backdrop_path"] as? String
                    fetchedMovie.originalLanguage = movie["original_language"] as? String
                    fetchedMovie.originalTitle = movie["original_title"] as? String
                    fetchedMovie.overview = movie["overview"] as? String
                    fetchedMovie.posterPath = movie["poster_path"] as? String
                    fetchedMovie.releaseDate = movie["release_date"] as? String
                    fetchedMovie.releaseYear = String(fetchedMovie.releaseDate?.prefix(4) ?? "")
                    fetchedMovie.title = movie["title"] as? String
                    fetchedMovie.popularity = movie["popularity"] as? Double ?? 0.0
                    fetchedMovie.voteCount = movie["voteCount"] as? Int64 ?? 0
                    fetchedMovie.voteAverage = movie["voteAverage"] as? Double ?? 0.0
                    
                    MMPersistentStore.sharedInstance.save(context: context)
                }
                
            }
            
        }
    }
    
}
