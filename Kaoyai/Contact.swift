//
//  Contact.swift
//  Khaoyai
//
//  Created by Amorn Apichattanakul on 12/15/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation
import CoreData


class Contact: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    struct key  {
        static let id = "ID"
        static let section = "Contacts"
        static let telno = "tel"
        static let title = "name"
    }
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject],context:NSManagedObjectContext){
        
        let entity =  NSEntityDescription.entityForName("Contact", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        id = dictionary[key.id] as? NSNumber
        section = dictionary[key.section] as? String
        telNo = dictionary[key.telno] as? String
        title = dictionary[key.title] as? String
    }
}
