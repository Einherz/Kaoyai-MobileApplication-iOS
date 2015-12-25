//
//  Home+CoreDataProperties.swift
//  Khaoyai
//
//  Created by Amorn Apichattanakul on 12/14/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Home {

    @NSManaged var highest: NSNumber?
    @NSManaged var lowest: NSNumber?
    @NSManaged var now: NSNumber?
    @NSManaged var resort: String?
    @NSManaged var status: NSNumber?
    @NSManaged var visitor: NSNumber?
    @NSManaged var humid: NSNumber?

}
