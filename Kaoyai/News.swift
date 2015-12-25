//
//  News.swift
//  Khaoyai
//
//  Created by Amorn Apichattanakul on 12/14/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation
import CoreData


class News: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    struct key  {
        static let id = "id"
        static let title = "title"
        static let date = "date"
        static let content = "content"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject],context:NSManagedObjectContext){
        
        let entity =  NSEntityDescription.entityForName("News", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        id = dictionary[key.id] as? NSNumber
        title = dictionary[key.title] as? String
        content = dictionary[key.content] as? String
        date = dictionary[key.date] as? String
    }

}
