//
//  Contact+CoreDataProperties.swift
//  Khaoyai
//
//  Created by Amorn Apichattanakul on 12/15/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Contact {

    @NSManaged var id: NSNumber?
    @NSManaged var section: String?
    @NSManaged var telNo: String?
    @NSManaged var title: String?

}
