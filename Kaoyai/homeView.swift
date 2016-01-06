//
//  ViewController.swift
//  Kaoyai
//
//  Created by Amorn Apichattanakul on 10/27/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import UIKit
import CoreData

class homeView: UIViewController,NSFetchedResultsControllerDelegate,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var humid: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var tempNow: UILabel!
    @IBOutlet var rightV: UIView!
    @IBOutlet var leftV: UIView!
    @IBOutlet var tabNameV: UIView!
    @IBOutlet var visitorsAmount: UILabel!
    @IBOutlet var resortAmount: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var statusImg: UIImageView!
    @IBOutlet var tabWidth: NSLayoutConstraint!
    
    var versionsArray = [NSNumber]()
    var updatesArray = Array<NSIndexPath>()
    var coloursArray = [UIColor(red:0.93, green:0.78, blue:0.19, alpha:1.0),
                        UIColor(red:0.06, green:0.72, blue:0.61, alpha:1.0),
                        UIColor(red:0.18, green:0.59, blue:0.82, alpha:1.0),
                        UIColor(red:0.58, green:0.35, blue:0.64, alpha:1.0),
                        UIColor(red:0.91, green:0.06, blue:0.47, alpha:1.0)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayDetails:", name: "DisplaySpotlightSearch", object: nil)
        
        self.tableView.registerNib(UINib(nibName: "localNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        rightV.layer.cornerRadius = 8;
        leftV.layer.cornerRadius = 8;
        rightV.layer.borderWidth = 1;
        leftV.layer.borderWidth = 1;
        rightV.layer.borderColor = UIColor.lightGrayColor().CGColor;
        leftV.layer.borderColor = UIColor.lightGrayColor().CGColor;
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("goToWeb"))
        self.rightV.addGestureRecognizer(tap)
        
        let pre = NSLocale.preferredLanguages()[0]
        
        print("language: \(pre)")
        
        let maskLayer = CAShapeLayer()
        
        if (pre.rangeOfString("th") != nil) {
    
            self.tabWidth.constant = 148
            
            var frame = tabNameV.bounds
            frame.size.width = 148
            
            maskLayer.path = UIBezierPath(roundedRect: frame, byRoundingCorners: UIRectCorner.TopLeft.union(.TopRight), cornerRadii: CGSizeMake(8, 8)).CGPath
            
            print("tab width: \(self.tabWidth.constant) and tab: \(self.tabNameV)")
        }else{
            
            print("language in else")
            
            self.tabWidth.constant = 98
            
            var frame = tabNameV.bounds
            frame.size.width = 98
            
            maskLayer.path = UIBezierPath(roundedRect: frame, byRoundingCorners: UIRectCorner.TopLeft.union(.TopRight), cornerRadii: CGSizeMake(8, 8)).CGPath
        }
        
        tabNameV.layer.mask = maskLayer
        
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
            try fetchedNewsController.performFetch()
            try fetchedHomeController.performFetch()
        } catch {
            print("error")
        }
        
        fetchedResultsController.delegate = self
        fetchedHomeController.delegate = self
        fetchedNewsController.delegate = self
        
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
            
            self.versionsArray.append(1.0)
            self.versionsArray.append(1.0)
            self.versionsArray.append(1.0)
            self.versionsArray.append(1.0)
        
            let versionDB = Version(dictionary: VersionData, context: sharedContext)
            self.sharedContext.performBlockAndWait({ () -> Void in
                dbConnector.sharedInstance().saveContext() })
        }

        let api = apiLoader()
        api.getDataAPI(config.TEMPERATURE) { (jsonData) -> () in
            if(jsonData.count > 0){
                self.view.makeToast("Getting Information...", duration: 1.0, position: CSToastPositionBottom)
                
                print("fetch item : \(self.fetchedHomeController.fetchedObjects?.count)")
                if(self.fetchedHomeController.fetchedObjects?.count > 0){
                    for homeController in self.fetchedHomeController.fetchedObjects!
                    {
                        print("home : \(homeController)")
                        let data = homeController as! Home
                        print("value :\(data)")
                        self.tempNow.text = String(data.valueForKey(Home.key.now) as! NSNumber) + "˚"
                        self.maxTemp.text = String(data.valueForKey(Home.key.high) as! NSNumber) + "˚"
                        self.minTemp.text = String(data.valueForKey(Home.key.low) as! NSNumber) + "˚"
                        self.humid.text = String(data.valueForKey(Home.key.humid) as! NSNumber) + "%"
                        self.visitorsAmount.text = String(data.valueForKey(Home.key.visitor) as! NSNumber)
                        //                    self.resortAmount.text = (data.valueForKey(Home.key.resort) as! String)
                        
                        if data.valueForKey(Home.key.status) as! NSNumber == 1 {
                            
                            self.statusImg.image = UIImage(named: "sun")
                            
                        }else if data.valueForKey(Home.key.status) as! NSNumber == 2 {
                            
                            self.statusImg.image = UIImage(named: "cloud")
                            
                        }else if data.valueForKey(Home.key.status) as! NSNumber == 3 {
                            
                            self.statusImg.image = UIImage(named: "rain")
                            
                        }
                    }
                }
            } else {
               self.view.makeToast("No Internet Connection", duration: 1.0, position: CSToastPositionBottom)
            }
        }
        
        api.checkVerion(config.NEWSVER, VersionDB: self.versionsArray[0] as Float , Indexed: 1, callback: { (allow) -> () in
            if(allow){
                api.getDataAPI(config.NEWS) { (jsonData) -> () in
                    print("Load news")
                   // print(jsonData)
                }
            }
        })
        
        api.checkVerion(config.HOWTOVER, VersionDB: self.versionsArray[1] as Float , Indexed: 2,callback: { (allow) -> () in
            if(allow){
                api.getDataAPI(config.HOWTO) { (jsonData) -> () in
                    print("Load how to")
                    //print(jsonData)
                    let tryfuc = coreDataController()
                    tryfuc.saveImages(config.HOWTO)
                    
                   
                }
            }
            
            let aaa = coreDataController()
            let allE = aaa.getAllEntities("Howto") as! [Howto]
            print("ALL HOW TO: \(allE.count)")
            
            api.checkVerion(config.MAPVER, VersionDB: self.versionsArray[2] as Float , Indexed: 3,callback: { (allow) -> () in
                if(allow){
                    api.getDataAPI(config.MAP) { (jsonData) -> () in
                        print("Load Map")
                        // print(jsonData)
                        let tryfuc = coreDataController()
                        tryfuc.saveImages(config.MAP)
                        
                        print("all map added: \(tryfuc.getAllEntities("Map"))")
                    }
                }
            })
        })
        
        
        api.checkVerion(config.CONTACTVER, VersionDB: self.versionsArray[3] as Float , Indexed: 4,callback: { (allow) -> () in
            if(allow){
                api.getDataAPI(config.CONTACT) { (jsonData) -> () in
                    print("Load Contact")
                    //print(jsonData)
                }
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Home")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject:AnyObject])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayDetails(notification: NSNotification) {
        
        if notification.userInfo!["objType"] as! String == "Howto" {
            
            self.performSegueWithIdentifier("toHowTo", sender: notification.object)
            
        }else{
            
            self.performSegueWithIdentifier("toMap", sender: notification.object)
        }
    }
    
    func goToWeb() {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.dnp.go.th/parkreserve/reservation.asp?lg=1")!)
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
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "highest", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = fetchedNewsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! localNewsTableViewCell
        
        
        let news = fetchedNewsController.objectAtIndexPath(indexPath) as! News
        
        
        print("indexpath colour: \(indexPath.row)")
        
        if (indexPath.row % 5 == 0) {
            cell.backgroundColor = coloursArray[0]
        }else if (indexPath.row % 5 == 1) {
            cell.backgroundColor = coloursArray[1]
        }else if (indexPath.row % 5 == 2) {
            cell.backgroundColor = coloursArray[2]
        }else if (indexPath.row % 5 == 3) {
            cell.backgroundColor = coloursArray[3]
        }else if (indexPath.row % 5 == 4) {
            cell.backgroundColor = coloursArray[4]
        }
        
        configureCell(cell, news: news);
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("toDetails", sender: indexPath);
    }
    
    
    lazy var fetchedNewsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "News")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    var sharedContext: NSManagedObjectContext {
        return dbConnector.sharedInstance().managedObjectContext
    }

    
    
    // MARK: - Configure Cell
    
    func configureCell(cell: localNewsTableViewCell, news: News) {
        
        cell.newsTitle.text = news.title
        cell.newsDate.text = news.date
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
        print("changeContent")
        
        if controller == self.fetchedNewsController {
            
            self.tableView.beginUpdates()
            
        }else if controller == self.fetchedHomeController {
            
            print("Home will change content")
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        print("did change section")
        
        if controller == self.fetchedNewsController {
            
            switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            default:
                return
            }
        }else if controller == self.fetchedHomeController {
            
            print("Home did change section")
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        print("did change object")
        
        if controller == self.fetchedNewsController {
            
            switch type {
            case .Insert:
                let thisIP = NSIndexPath(forRow: (newIndexPath?.row)!+1, inSection: (newIndexPath?.section)!)
                let sectionInfo = fetchedNewsController.sections![(newIndexPath?.section)!] as NSFetchedResultsSectionInfo
                if thisIP.row < sectionInfo.numberOfObjects {
                    
                    updatesArray.append(thisIP)
                }
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
                
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                
            case .Update:
                print("update indexpath: \(indexPath)")
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as! localNewsTableViewCell
                let news = controller.objectAtIndexPath(indexPath!) as! News
                if (indexPath!.row % 5 == 0) {
                    cell.backgroundColor = coloursArray[0]
                }else if (indexPath!.row % 5 == 1) {
                    cell.backgroundColor = coloursArray[1]
                }else if (indexPath!.row % 5 == 2) {
                    cell.backgroundColor = coloursArray[2]
                }else if (indexPath!.row % 5 == 3) {
                    cell.backgroundColor = coloursArray[3]
                }else if (indexPath!.row % 5 == 4) {
                    cell.backgroundColor = coloursArray[4]
                }
                self.configureCell(cell, news: news)
                
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            }
        }else if controller == self.fetchedHomeController{
            
            print("Home did change object")
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        print("did change content")
        
        if controller == self.fetchedNewsController {
            
            self.tableView.endUpdates()
            
            print("updates array: \(self.updatesArray)")
            
            for var i = 0; i<self.updatesArray.count; i++ {
                
                self.tableView.reloadRowsAtIndexPaths([self.updatesArray[i]], withRowAnimation: .Fade)
            }
            self.updatesArray.removeAll()
            
            print("updates array: \(self.updatesArray)")
            
        }else if controller == self.fetchedHomeController{
            
            print("Home did change content")
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toDetails") {

            let controller = segue.destinationViewController as! howtoDetailView
            let news = fetchedNewsController.objectAtIndexPath(sender as! NSIndexPath) as! News
            
            controller.contentDet = news.content!
            controller.titleS = news.title!
            
            print("content: \(news.content)")
        
        }else if (segue.identifier == "toHowTo") {
            
            let destView = segue.destinationViewController as! howtoDetailView
            let howTo = sender as! Howto
            
            destView.contentDet = howTo.content! as NSString
            destView.imgPath = howTo.image!
            destView.titleS = howTo.topics!
            
        }else if (segue.identifier == "toMap") {
            
            let mapC = sender as! Map
            let destView = segue.destinationViewController as! mapDetailView
            
            print("mapC: " + String(mapC))
            
            print("mapC how to: " + String(mapC.howto?.allObjects))
            
            destView.contentString = mapC.content
            destView.imgPath = mapC.image
            destView.topicS = mapC.title
            
            print(mapC.howto?.allObjects)
            
            if mapC.howto != nil {
                destView.howToDet = mapC.howto?.allObjects as! [Howto]
            }
        }
    }
}

