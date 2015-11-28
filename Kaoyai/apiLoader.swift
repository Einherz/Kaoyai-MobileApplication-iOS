//
//  apiLoader.swift
//  Kaoyai
//
//  Created by Amorn Apichattanakul on 11/12/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation


class apiLoader{
    let basedAPI:String = "http://www.thethanisorn.com/khaoyai/api/"
    let tempLog:String = "tempnow.php"
    
    func getDataAPI(apiCaller:String, callback:(jsonData:NSDictionary) -> ()){

        let manager = AFHTTPSessionManager(baseURL: NSURL(string: basedAPI))
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.GET(apiCaller, parameters: nil, success: { task, responseObject in
            //Save Data in Database First then reply back to Main page
            
            //Get Object at first Index because API is Array of Json
            callback(jsonData: responseObject.objectAtIndex(0) as! NSDictionary)
            }, failure: { task, error in
                print("Problem :  \(error.localizedDescription)");
            })
    }
    
    func postDataAPI(userID:String, callback:(jsonData:NSDictionary) -> ()){
        
    }
    
}
