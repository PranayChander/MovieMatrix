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
        
        MMPersistentStore.sharedInstance.resetMemoryContext()
        
        if MMUtilities.sharedInstance.isUITesting() {
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        }
        
        if MMUtilities.sharedInstance.isValidSession() {
            MMPersistentStore.sharedInstance.resetMemoryContext()
            let MMtabBar = UIStoryboard().getVC(storyboard: .main, viewControllerIdentifier: .tabBarController) as? MMTabBarController
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
        let container = NSPersistentContainer(name: "MovieMatrix")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate {
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        MMPersistentStore.sharedInstance.save(context: MMPersistentStore.sharedInstance.mainManagedObjectContext)
        showSplashScreen(shouldShow: true)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        showSplashScreen(shouldShow: false)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        MMPersistentStore.sharedInstance.save(context: MMPersistentStore.sharedInstance.mainManagedObjectContext)
    }
    
    func showSplashScreen(shouldShow: Bool) {
        self.window?.endEditing(true)
        if shouldShow {
            if self.splashVC == nil {
                self.splashVC = UIStoryboard().getVC(storyboard: .main, viewControllerIdentifier: .splashScreenController) as? SplashScreenViewController
            }
            self.window?.addSubview(self.splashVC!.view)
        } else {
            self.splashVC?.view.removeFromSuperview()
            self.splashVC = nil
        }
    }
}
