//
//  News+CoreDataProperties.swift
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

extension News {

    @NSManaged var content: String?
    @NSManaged var date: String?
    @NSManaged var title: String?
    @NSManaged var id: NSNumber?

}
