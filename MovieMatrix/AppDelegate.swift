//
//  AppDelegate.swift
//  MovieMatrix
//
//  Created by pranay chander on 06/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var splashVC: UIViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if MMUtilities.sharedInstance.isValidSession() {
            let MMtabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MMTabBarController") as? MMTabBarController
            window?.rootViewController = MMtabBar
            window?.makeKeyAndVisible()
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if components?.scheme == "moviematrix" && components?.path == "authenticate" {
            let loginVC = window?.rootViewController as! LoginViewController
            MMNetworkClient.startSession(completion: loginVC.handleSession(sessionResponse:error:))
            return true
        }
        return false
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MovieMatrix")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension AppDelegate {
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        showSplashScreen(shouldShow: true)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        showSplashScreen(shouldShow: false)
    }
    
    func showSplashScreen(shouldShow: Bool) {
        self.window?.endEditing(true)
        if shouldShow {
            if self.splashVC == nil {
                self.splashVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SplashScreenViewController") as? SplashScreenViewController
            }
            self.window?.addSubview(self.splashVC!.view)
        } else {
            self.splashVC?.view.removeFromSuperview()
            self.splashVC = nil
        }
    }
}
