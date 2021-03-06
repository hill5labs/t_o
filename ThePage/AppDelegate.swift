//
//  AppDelegate.swift
//  ThePage
//
//  Created by Thomas Lippert on 4/21/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let ud = NSUserDefaults.standardUserDefaults()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        if let data = ud.objectForKey("persistantData") as? NSData {
            persistantData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? PersistantData
        } else {
            persistantData = PersistantData()
        }
        let resourcePath = NSBundle.mainBundle().resourcePath
        
        var error = NSErrorPointer()
        var directoryContents = NSFileManager.defaultManager().contentsOfDirectoryAtPath(resourcePath!, error: error)
        

        if let resourceStrings = directoryContents as? [String] {
            
            for resource in resourceStrings {
                if resource.rangeOfString("epub") != nil {
                    println(resource)
                    let book = Book(recName: resource)
                    allBooks.append(book)
                    if persistantData?.pageDataList!.filter({$0.title == book.title}).first == nil {
                        
                        persistantData?.pageDataList?.append(PersistantPage(newTitle: book.title!))
                    }
                }
            }
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        ud.setObject(NSKeyedArchiver.archivedDataWithRootObject(persistantData!), forKey: "persistantData")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        ud.setObject(NSKeyedArchiver.archivedDataWithRootObject(persistantData!), forKey: "persistantData")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        if let data = ud.objectForKey("persistantData") as? NSData {
            persistantData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? PersistantData
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        ud.setObject(NSKeyedArchiver.archivedDataWithRootObject(persistantData!), forKey: "persistantData")
    }


}

