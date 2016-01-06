//
//  Howto.swift
//  Khaoyai
//
//  Created by Amorn Apichattanakul on 1/6/2559 BE.
//  Copyright © 2559 Amorn Apichattanakul. All rights reserved.
//

import Foundation
import CoreData


class Howto: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    struct key  {
        static let id = "ID"
        static let image = "Image"
        static let topic = "Topic"
        static let date = "Date"
        static let content = "Detail"
        static let type = "Type"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject],context:NSManagedObjectContext){
        
        let entity =  NSEntityDescription.entityForName("Howto", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        id = dictionary[key.id] as? NSNumber
        image = dictionary[key.image] as? String
        topics = dictionary[key.topic] as? String
        date = dictionary[key.date] as? String
        content = dictionary[key.content] as? String
        type = dictionary[key.type] as? NSNumber
    }
}

