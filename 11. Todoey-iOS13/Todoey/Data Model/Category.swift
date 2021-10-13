//
//  Category.swift
//  Todoey
//
//  Created by Usama Fouad on 10/10/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    // The forward relationship
    let items = List<Item>()
}
