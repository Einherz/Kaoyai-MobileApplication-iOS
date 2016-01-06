//
//  Map+CoreDataProperties.swift
//  Khaoyai
//
//  Created by Amorn Apichattanakul on 1/6/2559 BE.
//  Copyright © 2559 Amorn Apichattanakul. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Map {

    @NSManaged var content: String?
    @NSManaged var id: NSNumber?
    @NSManaged var image: String?
    @NSManaged var imagecover: String?
    @NSManaged var title: String?
    @NSManaged var howto: NSSet?

}
