//
//  apiLoader.swift
//  Kaoyai
//
//  Created by Amorn Apichattanakul on 11/12/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation
import CoreData

class apiLoader:NSObject,NSFetchedResultsControllerDelegate{
    
    func getDataAPI(apiCaller:String, callback:(jsonData:NSArray) -> ()){
        
        let data:NSMutableArray = []
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: config.basedAPI))
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.GET(apiCaller, parameters: nil, success: { task, responseObject in
            //Save Data in Database First then reply back to Main page
            let dbSaver = coreDataController()
            let response = dbSaver.saveData(responseObject as! NSArray, DB:apiCaller)
            //Get Object at first Index because API is Array of Json
            for Obj in responseObject as! NSArray{
                data.addObject(Obj)
            }
            callback(jsonData: data)
            }, failure: { task, error in
                print("Problem :  \(error.localizedDescription)");
                callback(jsonData: data)
            })
    }
    
    func checkVerion(apiCaller:String, VersionDB:Float, Indexed:Int,  callback:(allow:Bool) -> ()){
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: config.basedAPI))
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.GET(apiCaller, parameters: nil, success: { task, responseObject in
            
            //Read version in the table
            let loadVersion = Float(responseObject.objectAtIndex(0).valueForKey("Versions") as! String)
            print("Recent : \(VersionDB) News : \(loadVersion) for table : \(Indexed)")
            if(VersionDB < loadVersion){
                print("Updated Version from : \(VersionDB) to : \(loadVersion)")
                
                let request:NSFetchRequest = NSFetchRequest(entityName: "Version")
                var keyDB:String!
                
                switch Indexed{
                case 1 :
                    request.predicate = NSPredicate(format: "newsVersion == %f", VersionDB)
                    keyDB = "newsVersion"
                case 2 :
                    request.predicate = NSPredicate(format: "howtoVersion == %f", VersionDB)
                    keyDB = "howtoVersion"
                case 3 :
                    request.predicate = NSPredicate(format: "mapVersion == %f", VersionDB)
                    keyDB = "mapVersion"
                case 4 :
                    request.predicate = NSPredicate(format: "contactVersion == %f", VersionDB)
                    keyDB = "contactVersion"
                default :
                    print("missing Indexed")
                }
                
                do{
                    print("Query Database...")
                    let result = try sharedContext.executeFetchRequest(request)
                    print("Number of Query : \(result.count)")
                     print("at Key of Query : \(keyDB)")
                    if result.count != 0 {
                        result[0].setValue(loadVersion, forKey: keyDB)
                        try sharedContext.save()
                        print("Update Version Completed")
                    }
                } catch let error as NSError{
                    print("Error setDB :  \(error.localizedDescription)")
                }
                callback(allow: true)
            } else {
                callback(allow: false)
            }
            
            }, failure: { task, error in
                print("Problem :  \(error.localizedDescription)");
        })
    }
    
    func postDataAPI(userID:String, callback:(jsonData:NSDictionary) -> ()){
        
    }
        
}
    
    var sharedContext: NSManagedObjectContext {
        return dbConnector.sharedInstance().managedObjectContext
    }

