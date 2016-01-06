//
//  contactView.swift
//  Kaoyai
//
//  Created by Amorn Apichattanakul on 11/12/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation
import CoreData

class contactView:UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var coloursArray = [UIColor(red:0.93, green:0.78, blue:0.19, alpha:1.0),
                        UIColor(red:0.06, green:0.72, blue:0.61, alpha:1.0),
                        UIColor(red:0.18, green:0.59, blue:0.82, alpha:1.0),
                        UIColor(red:0.945, green:0.2, blue:0.176, alpha:1.0),
                        UIColor(red:0.58, green:0.35, blue:0.64, alpha:1.0),
                        UIColor(red:0.91, green:0.06, blue:0.47, alpha:1.0)]
    
    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayDetails:", name: "DisplaySpotlightSearch", object: nil)
        
        self.tableView.registerNib(UINib(nibName: "contactTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        do{
            try fetchedContactController.performFetch()
        } catch {
            print("error")
        }
        
        fetchedContactController.delegate = self
        
        self.tableView.layer.cornerRadius = 8
        
        let tap = UITapGestureRecognizer(target: self, action: ("hideKeyboard"))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Contact")
        
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
    
    lazy var fetchedContactController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        
        
        let sectionSortDescriptor = NSSortDescriptor(key: "section", ascending: true)
        let secondSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        
        let sortDescriptors = [sectionSortDescriptor, secondSortDescriptor]
        
        fetchRequest.sortDescriptors = sortDescriptors
        
        
        
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "section", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: "section",
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
//        print("title header: \(fetchedContactController.sections![section].name)")
//        return fetchedContactController.sections![section].name
        
        let sections = fetchedContactController.sections! as [NSFetchedResultsSectionInfo]
        
        print("title header: \(sections[section].name)")
        
        return sections[section].name
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        print("no of sections in tableview: \(fetchedContactController.sections!.count)")
        
        return fetchedContactController.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = fetchedContactController.sections![section] as NSFetchedResultsSectionInfo
        
        print("section contact: " + String(sectionInfo.numberOfObjects))
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! contactTableViewCell
        let cont = fetchedContactController.objectAtIndexPath(indexPath) as! Contact
        
        cell.ctName.text = cont.title
        cell.ctNumber.text = cont.telNo
        cell.ctPosition.text = cont.section
        
        if (indexPath.section % 5 == 0) {
            cell.colourV.backgroundColor = coloursArray[0]
        }else if (indexPath.section % 5 == 1) {
            cell.colourV.backgroundColor = coloursArray[1]
        }else if (indexPath.section % 5 == 2) {
            cell.colourV.backgroundColor = coloursArray[2]
        }else if (indexPath.section % 5 == 3) {
            cell.colourV.backgroundColor = coloursArray[3]
        }else if (indexPath.section % 5 == 4) {
            cell.colourV.backgroundColor = coloursArray[4]
        }else if (indexPath.section % 5 == 5) {
            cell.colourV.backgroundColor = coloursArray[5]
        }
        
        return cell
        
    }
    
    var sharedContext: NSManagedObjectContext {
        return dbConnector.sharedInstance().managedObjectContext
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
        print("content changes")
        
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
            
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! contactTableViewCell
            let cont = controller.objectAtIndexPath(indexPath!) as! Contact
            
            cell.ctName.text = cont.title
            cell.ctNumber.text = cont.telNo
            cell.ctPosition.text = cont.section
            
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
        
        var predicate:NSPredicate = NSPredicate(format: "TRUEPREDICATE")
        if searchText.characters.count != 0 {
            predicate = NSPredicate(format: "(title contains [cd] %@) || (section contains[cd] %@)", searchText, searchText)
        }
        
        fetchedContactController.fetchRequest.predicate = predicate
        
        do{
            try fetchedContactController.performFetch()
        } catch {
            print("error")
        }
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toHowTo") {
            
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