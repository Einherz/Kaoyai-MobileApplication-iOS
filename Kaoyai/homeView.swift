//
//  ViewController.swift
//  Kaoyai
//
//  Created by Amorn Apichattanakul on 10/27/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import UIKit
import CoreData

class homeView: UIViewController,NSFetchedResultsControllerDelegate {

    @IBOutlet weak var humid: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var tempNow: UILabel!
    
    var versionsArray = [NSNumber]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController!.tabBar.tintColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1.0)
        let item = self.tabBarController!.tabBar.items![0]
        let item1 = self.tabBarController!.tabBar.items![1]
        let item2 = self.tabBarController!.tabBar.items![2]
        let item3 = self.tabBarController!.tabBar.items![3]
        let item4 = self.tabBarController!.tabBar.items![4]
        
        //item.image = UIImage(named: "ElephantIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item.selectedImage = UIImage(named: "ElephantIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        //item1.image = UIImage(named: "BullIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item1.selectedImage = UIImage(named: "BullIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
       // item2.image = UIImage(named: "MonkeyIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item2.selectedImage = UIImage(named: "MonkeyIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
       // item3.image = UIImage(named: "TigerIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item3.selectedImage = UIImage(named: "TigerIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
       // item4.image = UIImage(named: "DeerIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item4.selectedImage = UIImage(named: "DeerIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        //Fetching Data in CoreData before Checking network
        do{
            try fetchedResultsController.performFetch()
        } catch {
            print("error")
        }
        
        fetchedResultsController.delegate = self
        
        if(fetchedResultsController.fetchedObjects?.count > 0){
            for myVersion in fetchedResultsController.fetchedObjects!
            {
                print("Getting Version")
                let version = myVersion as! Version
                self.versionsArray.append(version.newsVersion!)
                self.versionsArray.append(version.howtoVersion!)
                self.versionsArray.append(version.mapVersion!)
                self.versionsArray.append(version.contactVersion!)
            }
        } else {
            //No data Version yet. Add first version into database
            print("Add Version, Call once")
            let VersionData: [String:AnyObject] = [
                Version.key.news : NSNumber(float: 1.0),
                Version.key.howto : NSNumber(float: 1.0),
                Version.key.map : NSNumber(float: 1.0),
                Version.key.contact : NSNumber(float: 1.0)
            ]
        
            let versionDB = Version(dictionary: VersionData, context: sharedContext)
            self.sharedContext.performBlockAndWait({ () -> Void in
                dbConnector.sharedInstance().saveContext() })
        }
        
        
        //Loading Total API at start because in National park mostly doesn't have Internet connection
        let api = apiLoader()
        api.getDataAPI(config.TEMPERATURE) { (jsonData) -> () in
            print("Load Temperature")
            print(jsonData)
            self.tempNow.text = (jsonData.objectAtIndex(0).valueForKey("nowtemp") as! String)
            self.maxTemp.text = (jsonData.objectAtIndex(0).valueForKey("maxtemp") as! String)
            self.minTemp.text = (jsonData.objectAtIndex(0).valueForKey("mintemp") as! String)
            self.humid.text = (jsonData.objectAtIndex(0).valueForKey("nowhumid") as! String)
        }
        
        api.checkVerion(config.NEWSVER, VersionDB: self.versionsArray[0] as Float , Indexed: 1, callback: { (allow) -> () in
            if(allow){
                api.getDataAPI(config.NEWS) { (jsonData) -> () in
                    print("Load news")
                    print(jsonData)
                }
            }
        })
        
        api.checkVerion(config.HOWTOVER, VersionDB: self.versionsArray[1] as Float , Indexed: 2,callback: { (allow) -> () in
            if(allow){
                api.getDataAPI(config.HOWTO) { (jsonData) -> () in
                    print("Load how to")
                    print(jsonData)
                }
            }
        })
        
        api.checkVerion(config.MAPVER, VersionDB: self.versionsArray[2] as Float , Indexed: 3,callback: { (allow) -> () in
            if(allow){
                api.getDataAPI(config.MAP) { (jsonData) -> () in
                    print("Load Map")
                    print(jsonData)
                }
            }
        })
        
        api.checkVerion(config.CONTACTVER, VersionDB: self.versionsArray[3] as Float , Indexed: 4,callback: { (allow) -> () in
            if(allow){
                api.getDataAPI(config.CONTACT) { (jsonData) -> () in
                    print("Load Contact")
                    print(jsonData)
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //// FetchController
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Version")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "newsVersion", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    lazy var fetchedHomeController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Home")
        
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    lazy var fetchedNewsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "News")
        
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    lazy var fetchedHowtoController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Howto")
        
       // fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    lazy var fetchedMapController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Map")
        
       // fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    lazy var fetchedContactController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    var sharedContext: NSManagedObjectContext {
        return dbConnector.sharedInstance().managedObjectContext
    }


}

