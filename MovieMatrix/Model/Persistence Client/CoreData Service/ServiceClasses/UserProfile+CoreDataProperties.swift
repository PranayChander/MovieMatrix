//
//  UserProfile+CoreDataProperties.swift
//  MovieMatrix
//
//  Created by pranay chander on 28/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//
//

import Foundation
import CoreData


extension UserProfile {
    
    @nonobjc public class func fetchUserProfileRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }
    
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var status: String?
    @NSManaged public var userId: Int64
    @NSManaged public var movie: UserMovie?
    
    @nonobjc public class func saveUserDetails(json: [String: Any]) {
        let context = MMPersistentStore.sharedInstance.mainManagedObjectContext
        var user: UserProfile?
        context.perform {
            let fetchRequest = fetchUserProfileRequest()
            let sortD = NSSortDescriptor(key: "userId", ascending: false)
            fetchRequest.sortDescriptors = [sortD]
            //            fetchRequest.fetchBatchSize = 5
            //            fetchRequest.fetchLimit = 2
            //            fetchRequest.propertiesToGroupBy = ["firstName"]
            //            fetchRequest.propertiesToFetch
            do {
                user =  try context.fetch(fetchRequest).first
            } catch {
                print("User Fetch Rewuest failed")
            }
            if let userEntity = user {
                userEntity.userId = json["user_id"] as! Int64
                userEntity.firstName = json["first_name"] as? String
                userEntity.lastName = json["last_name"] as? String
                userEntity.phoneNumber = json["phone_number"] as? String
                userEntity.status = json["status"] as? String
                userEntity.city = json["city"] as? String
                userEntity.country = json["country"] as? String
                
                MMPersistentStore.sharedInstance.save(context: context)
            } else {
                let userEntity = NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: context) as! UserProfile
                userEntity.userId = json["user_id"] as! Int64
                userEntity.firstName = json["first_name"] as? String
                userEntity.lastName = json["last_name"] as? String
                userEntity.phoneNumber = json["phone_number"] as? String
                userEntity.status = json["status"] as? String
                userEntity.city = json["city"] as? String
                userEntity.country = json["country"] as? String
                
                MMPersistentStore.sharedInstance.save(context: context)
            }
        }
    }
    
    @nonobjc public class func getUserDetails() -> UserProfile? {
        let context = MMPersistentStore.sharedInstance.mainManagedObjectContext
        var user: UserProfile?
            let fetchRequest = fetchUserProfileRequest()
            let sortD = NSSortDescriptor(key: "userId", ascending: false)
            fetchRequest.sortDescriptors = [sortD]
            do {
                user =  try context.fetch(fetchRequest).first
                return user
            } catch {
                print("User Fetch Rewuest failed")
                return nil
            }
            return nil
        }
}
