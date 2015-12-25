//
//  howtoView.swift
//  Kaoyai
//
//  Created by Amorn Apichattanakul on 11/12/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation
import CoreData

class howtoView:UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet var buttonView: UIView!
    @IBOutlet var b1: UIButton!
    @IBOutlet var b2: UIButton!
    @IBOutlet var b3: UIButton!
    @IBOutlet var b4: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headView: UIView!
    
    var versionsArray = [NSNumber]()
    var numberFilter: NSNumber!
    
    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayDetails:", name: "DisplaySpotlightSearch", object: nil)
        
        self.buttonView.layer.cornerRadius = 10;
        self.tableView.registerNib(UINib(nibName: "howToTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        numberFilter = 1
        
        let predicate2:NSPredicate = NSPredicate(format: "(type == %@)", self.numberFilter)
        
        fetchedHowtoController.fetchRequest.predicate = predicate2
        
        do{
            try fetchedHowtoController.performFetch()
        } catch {
            print("error")
        }
        
        fetchedHowtoController.delegate = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 180.0
        
        self.b1.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.b2.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.b3.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.b4.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        let tap = UITapGestureRecognizer(target: self, action: ("hideKeyboard"))
        let tap2 = UITapGestureRecognizer(target: self, action: ("hideKeyboard"))
        self.headView.addGestureRecognizer(tap)
        self.buttonView.addGestureRecognizer(tap2)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Howto")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject:AnyObject])
    }
    
    func displayDetails(notification: NSNotification) {
        
        if notification.userInfo!["objType"] as! String == "Howto" {
            
            self.performSegueWithIdentifier("toHowTo", sender: notification.object)
            
        }else{
            
            self.performSegueWithIdentifier("toMap", sender: notification.object)
        }
    }
    
    func hideKeyboard() {
        
        self.view.endEditing(true)
    }
    
    @IBAction func choosingMenu(sender: AnyObject) {
        
        if sender.tag == 21 {
            
            self.numberFilter = 1
            
            let img1 = UIImage(named: "personW")
            let img2 = UIImage(named: "animal")
            let img3 = UIImage(named: "stop")
            let img4 = UIImage(named: "event")
            
            self.b1.setImage(img1, forState: .Normal)
            self.b2.setImage(img2, forState: .Normal)
            self.b3.setImage(img3, forState: .Normal)
            self.b4.setImage(img4, forState: .Normal)
            
        }else if sender.tag == 22 {
            
            self.numberFilter = 2
            
            let img1 = UIImage(named: "person")
            let img2 = UIImage(named: "animalW")
            let img3 = UIImage(named: "stop")
            let img4 = UIImage(named: "event")
            
            self.b1.setImage(img1, forState: .Normal)
            self.b2.setImage(img2, forState: .Normal)
            self.b3.setImage(img3, forState: .Normal)
            self.b4.setImage(img4, forState: .Normal)
            
        }else if sender.tag == 23 {
            
            self.numberFilter = 3
            
            let img1 = UIImage(named: "person")
            let img2 = UIImage(named: "animal")
            let img3 = UIImage(named: "stopW")
            let img4 = UIImage(named: "event")
            
            self.b1.setImage(img1, forState: .Normal)
            self.b2.setImage(img2, forState: .Normal)
            self.b3.setImage(img3, forState: .Normal)
            self.b4.setImage(img4, forState: .Normal)
            
        }else if sender.tag == 24 {
            
            self.numberFilter = 4
            
            let img1 = UIImage(named: "person")
            let img2 = UIImage(named: "animal")
            let img3 = UIImage(named: "stop")
            let img4 = UIImage(named: "eventW")
            
            self.b1.setImage(img1, forState: .Normal)
            self.b2.setImage(img2, forState: .Normal)
            self.b3.setImage(img3, forState: .Normal)
            self.b4.setImage(img4, forState: .Normal)
        }
        
        var predicate:NSPredicate = NSPredicate(format: "(type == %@)", self.numberFilter)
        if self.searchBar.text!.characters.count != 0 {
            predicate = NSPredicate(format: "((topics contains [cd] %@) || (content contains[cd] %@)) && (type == %@)", self.searchBar.text!, self.searchBar.text!, self.numberFilter)
        }
        
        fetchedHowtoController.fetchRequest.predicate = predicate
        
        do{
            try fetchedHowtoController.performFetch()
        } catch {
            print("error")
        }
        
        tableView.reloadData()
    }
    
    lazy var fetchedHowtoController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Howto")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = fetchedHowtoController.sections![section] as NSFetchedResultsSectionInfo
        
        print("section: " + String(sectionInfo.numberOfObjects))
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! howToTableViewCell
        let howTo = fetchedHowtoController.objectAtIndexPath(indexPath) as! Howto
        
        cell.topic.text = howTo.topics
        
        print("type: \(howTo.type)")
        
        if howTo.type == 1 {
            
            cell.htIcon.image = UIImage(named: "personG")
            
        }else if howTo.type == 2 {
            
            cell.htIcon.image = UIImage(named: "animalG")
            
        }else if howTo.type == 3 {
            
            cell.htIcon.image = UIImage(named: "stopG")
            
        }else if howTo.type == 4 {
            
            cell.htIcon.image = UIImage(named: "eventG")
        }
        
        if howTo.image != nil {
            
            let url = NSURL(string: self.pathForIdentifier(howTo.image!, folder: "Howto")) 
            if let data = NSData(contentsOfFile: (url?.path)!) {
                
                cell.htImg.image = UIImage(data: data)
                
            }else{
                cell.htImg.image = nil;
            }
        }else{
            cell.htImg.image = nil;
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("toDetails", sender: indexPath);
    }
    
    var sharedContext: NSManagedObjectContext {
        return dbConnector.sharedInstance().managedObjectContext
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! howToTableViewCell
            let howTo = controller.objectAtIndexPath(indexPath!) as! Howto
            cell.topic.text = howTo.topics
            cell.htIcon.image = UIImage(named: "BullIcon")
            
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("search bar txt: \(searchText)")
        
        var predicate:NSPredicate = NSPredicate(format: "(type == %@)", self.numberFilter)
        if searchText.characters.count != 0 {
            predicate = NSPredicate(format: "((topics contains [cd] %@) || (content contains[cd] %@)) && (type == %@)", searchText, searchText, self.numberFilter)
        }
        
        fetchedHowtoController.fetchRequest.predicate = predicate
        
        do{
            try fetchedHowtoController.performFetch()
        } catch {
            print("error")
        }
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toDetails" {
            
            let howToC = fetchedHowtoController.objectAtIndexPath(sender as! NSIndexPath) as! Howto
            let destView = segue.destinationViewController as! howtoDetailView
            
            print(howToC)
            
            destView.contentDet = howToC.content! as NSString
            destView.imgPath = howToC.image!
            destView.titleS = howToC.topics!
        
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
    
    func pathForIdentifier(identifier: String, folder:String) -> String {
        let documentsDirectoryURL:NSURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)[0] as NSURL
        
        let urlPath = documentsDirectoryURL.absoluteString
        let filefolder = urlPath.stringByAppendingString("/"+folder)
        let folderPath = documentsDirectoryURL.URLByAppendingPathComponent(folder)
        
        if !NSFileManager.defaultManager().fileExistsAtPath(filefolder){
            do{
                try  NSFileManager.defaultManager().createDirectoryAtPath(folderPath.path!, withIntermediateDirectories: true, attributes: nil)
            } catch {
//                print("Problem at Create Folder : \(error.localizedDescription)")
            }
        }
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(folder+"/"+identifier)
        
        return fullURL.path!
    }
}
