//
//  Category.swift
//  Todoey
//
//  Created by viswa kodela on 5/13/18.
//  Copyright © 2018 viswa kodela. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    
    var items = List<Item>()
    
}
