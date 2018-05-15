//
//  Item.swift
//  Todoey
//
//  Created by viswa kodela on 5/13/18.
//  Copyright © 2018 viswa kodela. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
