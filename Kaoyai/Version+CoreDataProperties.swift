//
//  Version+CoreDataProperties.swift
//  Khaoyai
//
//  Created by Amorn Apichattanakul on 12/11/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Version {

    @NSManaged var contactVersion: NSNumber?
    @NSManaged var howtoVersion: NSNumber?
    @NSManaged var newsVersion: NSNumber?
    @NSManaged var mapVersion: NSNumber?

}
