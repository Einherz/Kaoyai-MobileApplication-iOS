//
//  Map.swift
//  Khaoyai
//
//  Created by Amorn Apichattanakul on 12/15/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation
import CoreData


class Map: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    struct key  {
        static let id = "ID"
        static let image = "image"
        static let thumb = "imagecover"
        static let topic = "Topic"
        static let howto = "howto"
        static let content = "Detail"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject],context:NSManagedObjectContext){
        
        let entity =  NSEntityDescription.entityForName("Map", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        id = dictionary[key.id] as? NSNumber
        image = dictionary[key.image] as? String
        imagecover = dictionary[key.thumb] as? String
        title = dictionary[key.topic] as? String
        howto = dictionary[key.howto] as? NSSet
        content = dictionary[key.content] as? String
    }

}
