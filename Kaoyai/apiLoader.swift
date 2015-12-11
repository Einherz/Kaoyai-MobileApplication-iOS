//
//  apiLoader.swift
//  Kaoyai
//
//  Created by Amorn Apichattanakul on 11/12/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation
import CoreData

class apiLoader{
    
    func getDataAPI(apiCaller:String, callback:(jsonData:NSArray) -> ()){
        
        let data:NSMutableArray = []
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: config.basedAPI))
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.GET(apiCaller, parameters: nil, success: { task, responseObject in
            //Save Data in Database First then reply back to Main page

            //Get Object at first Index because API is Array of Json
            for Obj in responseObject as! NSArray{
                data.addObject(Obj)
            }
            callback(jsonData: data)
            }, failure: { task, error in
                print("Problem :  \(error.localizedDescription)");
            })
    }
    
    func checkVerion(apiCaller:String, VersionDB:Float, Indexed:Int,  callback:(allow:Bool) -> ()){
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: config.basedAPI))
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.GET(apiCaller, parameters: nil, success: { task, responseObject in
            //Read version in the table
            let loadVersion = Float(responseObject.objectAtIndex(0).valueForKey("Versions") as! String)
            print(loadVersion)
            if(VersionDB < loadVersion){
                //Have to update this one is adding data//
                let data = Version(value: loadVersion!, dataDB: Indexed, context: self.sharedContext)
                self.sharedContext.performBlockAndWait({ () -> Void in
                    dbConnector.sharedInstance().saveContext() })
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
    
    var sharedContext: NSManagedObjectContext {
        return dbConnector.sharedInstance().managedObjectContext
    }
    
}
