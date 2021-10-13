//
//  Item.swift
//  Todoey
//
//  Created by Usama Fouad on 10/10/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    // LinkingObjects: is an auto-updating container type. It represents zero or more objects that are linked to its owning model object through a property relationship.
    
    // Reverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
