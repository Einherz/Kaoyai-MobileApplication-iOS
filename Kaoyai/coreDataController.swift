//
//  coreDataController.swift
//  Khaoyai
//
//  Created by Amorn Apichattanakul on 12/14/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation
import CoreData
import CoreSpotlight
import MobileCoreServices

class coreDataController{
    
    var DBName:String!
    var pathName:String!
    var status:String!
    
    func saveData(data:NSArray, DB:String){
    
        switch DB{
        case config.TEMPERATURE :
            print("save home")
            self.DBName = "Home"
            self.clearData()
            
            let database: [String:AnyObject] = [
                Home.key.high : Float(data.objectAtIndex(0).valueForKey("maxtemp") as! String)!,
                Home.key.low : Float(data.objectAtIndex(0).valueForKey("mintemp") as! String)!,
                Home.key.humid : Float(data.objectAtIndex(0).valueForKey("nowhumid") as! String)!,
                Home.key.now : Float(data.objectAtIndex(0).valueForKey("nowtemp") as! String)!,
               // Home.key.resort : data.objectAtIndex(0).valueForKey("homeamount") as! String,
                Home.key.status : Int(data.objectAtIndex(0).valueForKey("status") as! String)!,
                Home.key.visitor : Int(data.objectAtIndex(0).valueForKey("touramount") as! String)!
            ]
            let dbQuery = Home(dictionary: database, context: sharedContext)
            
            self.sharedContext.performBlock({ () -> Void in
                dbConnector.sharedInstance().saveContext()
            })
            
        case config.NEWS :
            self.DBName = "News"
            self.clearNewsData()
    
            //Update New Data
            for eachData in data{
                let myData = eachData as! NSDictionary
                    let database: [String:AnyObject] = [
                    News.key.id : Int(myData.valueForKey("ID") as! String)!,
                    News.key.title : myData.valueForKey("Topic") as! String,
                    News.key.date : myData.valueForKey("Date") as! String,
                    News.key.content : myData.valueForKey("Detail") as! String
                ]
                let dbQuery = News(dictionary: database, context: sharedContext)
                print("insert : \(database)")
            }
            self.sharedContext.performBlock({ () -> Void in
                dbConnector.sharedInstance().saveContext()
            })

            
           
        case config.HOWTO :
            self.DBName = "Howto"
            self.clearData()
            self.clearImages()
            //self.clearFiles()
            
            //Update New Data
            for eachData in data{
               
                let myData = eachData as! NSDictionary
                let database: [String:AnyObject] = [
                    Howto.key.id : Int(myData.valueForKey("ID") as! String)!,
                    Howto.key.topic : myData.valueForKey("Topic") as! String,
                    Howto.key.image : (myData.valueForKey("Image") as! String).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!,
                    Howto.key.date : myData.valueForKey("Date") as! String,
                    Howto.key.type : Int(myData.valueForKey("Type") as! String)!,
                    Howto.key.content : myData.valueForKey("Detail") as! String
                ]
                
                let attributeS = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
                attributeS.title = myData.valueForKey("Topic") as? String
                
                let item = CSSearchableItem(uniqueIdentifier: "How to:\(myData.valueForKey("ID") as! String)", domainIdentifier: "com.theamorn.Kaoyai", attributeSet: attributeS)
                CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item], completionHandler: { (error: NSError?) -> Void in
                    
                    if let error = error {
                        print("Indexing error: \(error.localizedDescription)")
                    }else{
                        print("Search item successfully indexed!: \(myData.valueForKey("Topic"))")
                    }
                })
                let dbQuery = Howto(dictionary: database, context: sharedContext)
            }
            self.sharedContext.performBlock({ () -> Void in
                dbConnector.sharedInstance().saveContext()
            })
            
        case config.MAP :
            self.DBName = "Map"
            self.clearData()
            self.clearImages()
                        
            //Update New Data
            for eachData in data{
                let myData = eachData as! NSDictionary
                var howtoKey = Set<Howto>()
                
                let keys = (myData.valueForKey("Howto") as! String).characters.split{$0 == ","}.map(String.init)
                print("key : \(keys)")
                for key in keys{
                    print("number of key : \(key)")
                    let fetchRequest = NSFetchRequest(entityName: "Howto")
                    fetchRequest.predicate = NSPredicate(format: "id == %i", Int(key)!)
                
                    do{
                        let fetchResult = try self.sharedContext.executeFetchRequest(fetchRequest) as! [Howto]
                        print("fetching : \(fetchResult.count)")
                        if (fetchResult.count > 0){
                            howtoKey.insert(fetchResult[0])
                            
                           // howtoKey.addObject(fetchResult[0])
                        }
                    } catch let error as NSError{
                        print("Problem updating : \(error.localizedDescription)")
                    }
                }
                
                let database: [String:AnyObject] = [
                    Map.key.id : Int(myData.valueForKey("ID") as! String)!,
                    Map.key.topic : myData.valueForKey("Topic") as! String,
                    Map.key.thumb : (myData.valueForKey("Smallimage") as! String).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!,
                    Map.key.image : (myData.valueForKey("Bigimage") as! String).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!,
                    Map.key.howto : howtoKey,
                    Map.key.content : myData.valueForKey("Detail") as! String
                ]
                
                let attributeS = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
                attributeS.title = myData.valueForKey("Topic") as? String
                
                let item = CSSearchableItem(uniqueIdentifier: "Map:\(myData.valueForKey("ID") as! String)", domainIdentifier: "com.theamorn.Kaoyai", attributeSet: attributeS)
                CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item], completionHandler: { (error: NSError?) -> Void in
                    
                    if let error = error {
                        print("Indexing error: \(error.localizedDescription)")
                    }else{
                        print("Search item successfully indexed!: \(myData.valueForKey("Topic"))")
                    }
                })
                
                
                let dbQuery = Map(dictionary: database, context: sharedContext)
            }
            self.sharedContext.performBlock({ () -> Void in
                 dbConnector.sharedInstance().saveContext()
            })
           
            
        case config.CONTACT :
            self.DBName = "Contact"
            self.clearData()
            
            for eachData in data{
                let myData = eachData as! NSDictionary
                
                for inData in myData.valueForKey("Data") as! NSArray{
                let database: [String:AnyObject] = [
                    Contact.key.id : Int(inData.valueForKey("ID") as! String)!,
                    Contact.key.title : inData.valueForKey("name") as! String,
                    Contact.key.section : myData.valueForKey("Contacts") as! String,
                    Contact.key.telno : inData.valueForKey("tel") as! String
                ]
                let dbQuery = Contact(dictionary: database, context: sharedContext)
                }
            }
            self.sharedContext.performBlock({ () -> Void in
                dbConnector.sharedInstance().saveContext()
            })
        
        default :
            print("no existed API")
        }
    }
    
    func saveImages(DB:String){
        print("Save Images")
        var requestQueue = [NSOperation]()
        
        switch DB{
        case config.HOWTO :
            let results = getAllEntities("Howto") as! [Howto]
            requestQueue = addingQueue(results,AtFolder: "Howto")
            self.status = "Howto"

        case config.MAP :
            let results = getAllEntities("Map") as! [Map]
            requestQueue = addingQueue(results,AtFolder: "Map")
             self.status = "Map"
            
        default :
            print("No Exist Database")
        }
        
        //Done Adding Object Start batching Download
        print("Start batching")
       
        let path = UIBezierPath()
        path.addArcWithCenter(CGPoint(x: 0, y: 0), radius: 50, startAngle: 0, endAngle: 360, clockwise: true)
  
        let progress = GradientCircularProgress()
        progress.show(message: "Updating...", style: BlueIndicatorStyle())
        
        let batches = AFURLConnectionOperation.batchOfRequestOperations(requestQueue as [NSOperation], progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
            //Working in here for saving each image
            print("Done \(numberOfFinishedOperations) from \(totalNumberOfOperations)")
//            if(self.status == "Howto" && self.pathName != ""){
//                 print("image this :\(self.pathName != "")")
//                self.updatingSpecificPath(self.getSpecificEntity("Howto", ImageName: self.pathName) as! Howto,AtFolder: "Howto")
//                
//            } else if(self.status == "Map"){
//                 print("image that :\(self.pathName)")
//                //self.updatingSpecificPath(self.getSpecificEntity("Map", ImageName: self.pathName) as! Map,AtFolder: "Map")
//            }
            //print("Progress \((Double(numberOfFinishedOperations)/Double(totalNumberOfOperations)))")
            },
            completionBlock : { (operations) -> Void in
            if(self.status == "Howto"){
                self.updatingPath(self.getAllEntities("Howto") as! [Howto],AtFolder: "Howto")
            } else if(self.status == "Map"){
                progress.dismiss()
                
                 let window = UIApplication.sharedApplication().keyWindow
                 window?.rootViewController?.view.makeToast("Update Completed", duration: 1.0, position: CSToastPositionBottom)
                self.updatingPath(self.getAllEntities("Map") as! [Map],AtFolder: "Map")
            }
        })
        NSOperationQueue.mainQueue().addOperations(batches as! [NSOperation], waitUntilFinished: false)
    }
    
    func addingQueue(entities:[AnyObject], AtFolder:String) -> [NSOperation]{
        var queueSum = [NSOperation]()
        
        for result in entities{
            
            if(AtFolder == "Map"){
                let imageThumb = result.valueForKey(Map.key.thumb) as! String
                let requestURL = NSURL(string: imageThumb)
                
                let request = NSURLRequest(URL: requestURL!)
                
                self.pathName = imageThumb.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!

                //should used this instead AFHTTPSessionManager
                let operation = AFHTTPRequestOperation(request: request)
                operation.responseSerializer = AFImageResponseSerializer()
                operation.outputStream = NSOutputStream(toFileAtPath: pathForIdentifier(imageThumb,folder: AtFolder), append: false)
                operation.queuePriority = .Low
                
                operation.completionBlock = {
                    //self.pathName = imagePath.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                    print("Finised download this thumb image : \(self.pathName)")
                }
                
                queueSum.append(operation)
                
                let imageFull = result.valueForKey(Map.key.image) as! String
                let requestURLFull = NSURL(string: imageFull)
                
                let requestFull = NSURLRequest(URL: requestURLFull!)
                
                //should used this instead AFHTTPSessionManager
                let operationFull = AFHTTPRequestOperation(request: requestFull)
                operationFull.responseSerializer = AFImageResponseSerializer()
                operationFull.outputStream = NSOutputStream(toFileAtPath: pathForIdentifier(imageFull,folder: AtFolder), append: false)
                operationFull.queuePriority = .Low
                
                queueSum.append(operationFull)
                
            } else {
                let imagePath = result.valueForKey(Howto.key.image) as! String
                let requestURL = NSURL(string: imagePath)
                let request = NSURLRequest(URL: requestURL!)
                
                let operation = AFHTTPRequestOperation(request: request)
                operation.responseSerializer = AFImageResponseSerializer()
                operation.outputStream = NSOutputStream(toFileAtPath: pathForIdentifier(imagePath,folder: AtFolder), append: false)
                operation.queuePriority = .Low
                
                self.pathName = imagePath.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                
                
                operation.setDownloadProgressBlock({ (bytesRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
                    print("Image Data : \(bytesRead) out of \(totalBytesRead) for total \(totalBytesExpectedToRead) by path \(self.pathName)")
                    //self.loader.progress = CGFloat(totalBytesRead/totalBytesExpectedToRead)
                })
                
                operation.completionBlock = {
                    //self.pathName = imagePath.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                    print("Finised download this image : \(self.pathName)")
                }
                queueSum.append(operation)
            }
        }
        return queueSum
    }
    
    
    func getAllEntities(DB:String) -> [AnyObject]? {
        let fetchRequest = NSFetchRequest(entityName:DB)
        
        do {
            let fetchedResults = try self.sharedContext.executeFetchRequest(fetchRequest) as [AnyObject]?
            return fetchedResults
        }
        catch let error as NSError {
            print("Could not fetch \(error.localizedDescription)")
             return nil
        }
    }
    
    func getSpecificEntity(DB:String, ImageName:String) -> [AnyObject]? {
        let fetchRequest = NSFetchRequest(entityName:DB)
        fetchRequest.predicate = NSPredicate(format: "image == %@", ImageName)
        
        do {
            let fetchedResults = try self.sharedContext.executeFetchRequest(fetchRequest) as [AnyObject]?
            return fetchedResults
        }
        catch let error as NSError {
            print("Could not fetch \(error.localizedDescription)")
            return nil
        }
    }
    
    func updatingSpecificPath(entities:AnyObject, AtFolder:String){
        
            if(AtFolder == "Howto"){
                let urlPath = entities.valueForKey(Howto.key.image) as! String
                let imageName = urlPath.characters.split{$0 == "/"}.map(String.init)
                print("url : \(imageName)")
                if(imageName.count > 0){
                    let localPath = imageName[imageName.count-1]
                    
                    print("new path Image \(localPath)")
                    
                    let fetchRequest = NSFetchRequest(entityName: AtFolder)
                    fetchRequest.predicate = NSPredicate(format: "image == %@", urlPath)
                    
                    do{
                        let fetchResult = try self.sharedContext.executeFetchRequest(fetchRequest) as! [Howto]
                        print("count mramorn 23 \(fetchResult.count) from \(AtFolder)")
                        if (fetchResult.count > 0){
                            fetchResult[0].setValue(localPath, forKey: "image")
                            
                            dbConnector.sharedInstance().saveContext()
                            print("new data updated From \(AtFolder)")
                        }
                    } catch let error as NSError{
                        print("Problem updating : \(error.localizedDescription)")
                    }
                }
            }
                
            else if(AtFolder == "Map"){
                let urlPath = entities.valueForKey(Map.key.image) as! String
                let urlThumb = entities.valueForKey(Map.key.thumb) as! String
                
                let imageName = urlPath.characters.split{$0 == "/"}.map(String.init)
                let imageThumb = urlThumb.characters.split{$0 == "/"}.map(String.init)
                
                print("url 2 : \(imageThumb)")
                
                if(imageName.count > 0){
                    
                    let localPath = imageName[imageName.count-1].stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                    let localThumb = imageThumb[imageThumb.count-1].stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                    print("new path Thumb \(localPath)")
                    
                    let fetchRequest = NSFetchRequest(entityName: AtFolder)
                    fetchRequest.predicate = NSPredicate(format: "image == %@", urlPath)
                    
                    do{
                        let fetchResult = try self.sharedContext.executeFetchRequest(fetchRequest) as! [Map]
                        if (fetchResult.count > 0){
                            fetchResult[0].setValue(localPath, forKey: "image")
                            fetchResult[0].setValue(localThumb, forKey: "imagecover")
                            self.sharedContext.performBlock({ () -> Void in
                                dbConnector.sharedInstance().saveContext()
                            })
                            print("new data updated From \(AtFolder)")
                        }
                    } catch let error as NSError{
                        print("Problem updating : \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func clearNewsData(){
        do{
            try fetchedResultsController.performFetch()
        } catch {
            print("error")
        }
        
        print("data clear : \(self.fetchedResultsController.fetchedObjects?.count)")
        if (self.fetchedResultsController.fetchedObjects?.count > 0){
            for section in self.fetchedResultsController.fetchedObjects!{
                let data = section as! News
                self.sharedContext.deleteObject(data)
            }
            self.sharedContext.performBlock({ () -> Void in
                dbConnector.sharedInstance().saveContext()
            })
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "News")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    //Remove All data in That Entity
    func clearData(){
        
        print("clear data : \(self.DBName)")
        let fetchRequest = NSFetchRequest(entityName: self.DBName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try sharedContext.executeRequest(deleteRequest)
            print("done")
        } catch let error as NSError {
            print ("Problem Clear Data: \(error.localizedDescription)")
        }
    }
    
    func clearImages(){
        print("Removing Images")
        //Working on removes only images that don't used 
        
        let documentsDirectoryURL:NSURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)[0] as NSURL
        
        let folderPath = documentsDirectoryURL.URLByAppendingPathComponent(self.DBName)
        
        do{
            let fileArray = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(folderPath.path!)
            for file in fileArray{
                try NSFileManager.defaultManager().removeItemAtPath(pathForIdentifier(self.DBName+"/"+file))
            }
        } catch let error as NSError{
            print("Error Remove Images \(error.localizedDescription)")
        }
    }
    
    
    var sharedContext: NSManagedObjectContext {
        return dbConnector.sharedInstance().managedObjectContext
    }
    
    func pathForIdentifier(identifier: String) -> String {
        let documentsDirectoryURL:NSURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)[0] as NSURL
        
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identifier)
        
        return fullURL.path!
    }
    
    static func getImage(){
        
    }
    
    func updatingPath(entities:[AnyObject], AtFolder:String){
        
        for result in entities{
            
            if(AtFolder == "Howto"){
            let urlPath = result.valueForKey(Howto.key.image) as! String
            let imageName = urlPath.characters.split{$0 == "/"}.map(String.init)
                
                if(imageName.count > 0){
                    let localPath = imageName[imageName.count-1].stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                    
                    print("new path Image \(localPath)")
                    
                    let fetchRequest = NSFetchRequest(entityName: AtFolder)
                    fetchRequest.predicate = NSPredicate(format: "image == %@", urlPath)
                    
                    do{
                        let fetchResult = try self.sharedContext.executeFetchRequest(fetchRequest) as! [Howto]
                        print("count mramorn 23 \(fetchResult.count) from \(AtFolder)")
                        if (fetchResult.count > 0){
                            fetchResult[0].setValue(localPath, forKey: "image")
                            
                            self.sharedContext.performBlock({ () -> Void in
                                dbConnector.sharedInstance().saveContext()
                            })
                             print("new data updated From \(AtFolder)")
                        }
                    } catch let error as NSError{
                        print("Problem updating : \(error.localizedDescription)")
                    }
                }
            }
            
            else if(AtFolder == "Map"){
                let urlPath = result.valueForKey(Map.key.image) as! String
                let urlThumb = result.valueForKey(Map.key.thumb) as! String
                
                let imageName = urlPath.characters.split{$0 == "/"}.map(String.init)
                let imageThumb = urlThumb.characters.split{$0 == "/"}.map(String.init)
                
                if(imageName.count > 0){
                
                let localPath = imageName[imageName.count-1].stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                let localThumb = imageThumb[imageThumb.count-1].stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                    
                print("new path image \(localPath)")
                print("new path Thumb \(localThumb)")
                
                let fetchRequest = NSFetchRequest(entityName: AtFolder)
                fetchRequest.predicate = NSPredicate(format: "image == %@", urlPath)
                
                do{
                    let fetchResult = try self.sharedContext.executeFetchRequest(fetchRequest) as! [Map]
                    if (fetchResult.count > 0){
                        fetchResult[0].setValue(localPath, forKey: "image")
                        fetchResult[0].setValue(localThumb, forKey: "imagecover")
                        self.sharedContext.performBlock({ () -> Void in
                            dbConnector.sharedInstance().saveContext()
                        })
                        print("new data updated From \(AtFolder)")
                    }
                } catch let error as NSError{
                    print("Problem updating : \(error.localizedDescription)")
                }
                }
                }
            }
             //dbConnector.sharedInstance().saveContext()
    }
    
    func pathForIdentifier(identifier: String, folder:String) -> String {
        let documentsDirectoryURL:NSURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)[0] as NSURL
        //but in coredate we save the full image
        let imageName = identifier.characters.split{$0 == "/"}.map(String.init)
       
        let urlPath = documentsDirectoryURL.absoluteString
        let filefolder = urlPath.stringByAppendingString("/"+folder)
        let folderPath = documentsDirectoryURL.URLByAppendingPathComponent(folder)
        
        if !NSFileManager.defaultManager().fileExistsAtPath(filefolder){
            do{
                try  NSFileManager.defaultManager().createDirectoryAtPath(folderPath.path!, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError{
                print("Problem at Create Folder : \(error.localizedDescription)")
            }
        }
        if(imageName.count > 0){
            let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(folder+"/"+imageName[imageName.count-1])
            return fullURL.path!
        } else {
            return ""
        }
        
        
    }
    
    func getItem(id: String, table: String) -> NSManagedObject {
        
        var item: NSManagedObject!
        
        let fetchRequest = NSFetchRequest(entityName: table)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do{
            let fetchResult = try self.sharedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            if (fetchResult.count > 0){
                item = fetchResult[0]
            }
        } catch let error as NSError{
            print("Problem updating : \(error.localizedDescription)")
        }
        
        return item
    }
}