//
//  mapView.swift
//  Kaoyai
//
//  Created by Amorn Apichattanakul on 11/12/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation
import CoreData

class mapView:UIViewController, NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet var collectionView: UICollectionView!
    
    var blockOperations: [NSBlockOperation] = []
    
    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayDetails:", name: "DisplaySpotlightSearch", object: nil)
        
        self.collectionView.registerNib(UINib(nibName: "mapCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        do{
            try fetchedMapController.performFetch()
        } catch {
            print("error")
        }
        
        fetchedMapController.delegate = self
    }
    
    deinit {
        // Cancel all block operations when VC deallocates
        for operation: NSBlockOperation in blockOperations {
            operation.cancel()
        }
        
        blockOperations.removeAll(keepCapacity: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Map")
        
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
    
    lazy var fetchedMapController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Map")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    var sharedContext: NSManagedObjectContext {
        return dbConnector.sharedInstance().managedObjectContext
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let sectionInfo = fetchedMapController.sections![section] as NSFetchedResultsSectionInfo
        
        print("section map: " + String(sectionInfo.numberOfObjects))
        
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "cell"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! mapCollectionViewCell
        let mapC = fetchedMapController.objectAtIndexPath(indexPath) as! Map
        
        cell.mapName.text = mapC.title
        
        print("map cell path: \(self.pathForIdentifier(mapC.imagecover!, folder: "Map"))")
        
        let url = NSURL(string: self.pathForIdentifier(mapC.imagecover!, folder: "Map"))
        if let data = NSData(contentsOfFile: (url?.path)!) {
            
            cell.mapImg.image = UIImage(data: data)
            
        }else{
            cell.mapImg.image = UIImage(named: "tempLogo");
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("toMapDetails", sender: indexPath)
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
        blockOperations.removeAll(keepCapacity: false)
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Insert:
//            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.insertSections(NSIndexSet(index: sectionIndex))
                    }
                })
            )
            
        case .Update:
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.reloadSections(NSIndexSet(index: sectionIndex))
                    }
                })
            )
            
        case .Delete:
//            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.deleteSections(NSIndexSet(index: sectionIndex))
                    }
                })
            )
            
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
//            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.insertItemsAtIndexPaths([newIndexPath!])
                    }
                })
            )
            
        case .Delete:
//            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.deleteItemsAtIndexPaths([indexPath!])
                    }
                })
            )
            
        case .Update:
//            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! howToTableViewCell
//            let howTo = controller.objectAtIndexPath(indexPath!) as! Howto
            
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.reloadItemsAtIndexPaths([indexPath!])
                    }
                })
            )
            
        case .Move:
//            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
//            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.moveItemAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
                    }
                })
            )
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
//        self.tableView.endUpdates()
        collectionView!.performBatchUpdates({ () -> Void in
            for operation: NSBlockOperation in self.blockOperations {
                operation.start()
            }
        }, completion: { (finished) -> Void in
                self.blockOperations.removeAll(keepCapacity: false)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toMapDetails" {
            
            let mapC = fetchedMapController.objectAtIndexPath(sender as! NSIndexPath) as! Map
            let destView = segue.destinationViewController as! mapDetailView
            
            destView.contentString = mapC.content
            destView.imgPath = mapC.image
            destView.topicS = mapC.title
            
            print(mapC.howto?.allObjects)
            
            if mapC.howto != nil {
                destView.howToDet = mapC.howto?.allObjects as! [Howto]
            }
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