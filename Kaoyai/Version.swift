//
//  Version.swift
//  Khaoyai
//
//  Created by Amorn Apichattanakul on 12/11/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation
import CoreData


class Version: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    struct key  {
        static let howto = "howtoVersion"
        static let map = "mapVersion"
        static let contact = "contactVersiontact"
        static let news = "newsVersion"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject],context:NSManagedObjectContext){
        
        let entity =  NSEntityDescription.entityForName("Version", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        newsVersion = dictionary[key.news] as? NSNumber
        howtoVersion = dictionary[key.howto] as? NSNumber
        mapVersion = dictionary[key.map] as? NSNumber
        contactVersion = dictionary[key.contact] as? NSNumber
    }
    
    
}
