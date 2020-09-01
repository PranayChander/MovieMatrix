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


extension UserProfile: Managed {
    
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
        let context = MMPersistentStore.sharedInstance.privateManagedObjectContext
        context.perform {
            let userID = json["user_id"] as! Int
            let userPredicate = NSPredicate(format: "userId == %d", userID)
            
            let userEntity = UserProfile.findOrCreate(in: context, matching: userPredicate) { (_) in }
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
    
    @nonobjc public class func getUserDetails(completion: @escaping(UserProfile?) -> Void) {
        let context = MMPersistentStore.sharedInstance.privateManagedObjectContext
        context.perform {
            completion(try! context.fetch(fetchUserProfileRequest()).first)
        }
    }
}
