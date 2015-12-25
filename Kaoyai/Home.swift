//
//  Home.swift
//  Khaoyai
//
//  Created by Amorn Apichattanakul on 12/14/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation
import CoreData


class Home: NSManagedObject {
    
// Insert code here to add functionality to your managed object subclass
    struct key  {
        static let high = "highest"
        static let low = "lowest"
        static let now = "now"
        static let resort = "resort"
        static let status = "status"
        static let visitor = "visitor"
        static let humid = "humid"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject],context:NSManagedObjectContext){
        
        let entity =  NSEntityDescription.entityForName("Home", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)

        highest = dictionary[key.high] as? NSNumber
        lowest = dictionary[key.low] as? NSNumber
        now = dictionary[key.now] as? NSNumber
        resort = dictionary[key.resort] as? String
        status = dictionary[key.status] as? NSNumber
        visitor = dictionary[key.visitor] as? NSNumber
        humid = dictionary[key.humid] as? NSNumber
    }
}
