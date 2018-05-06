//
//  item.swift
//  Todoey
//
//  Created by viswa kodela on 5/5/18.
//  Copyright © 2018 viswa kodela. All rights reserved.
//

import Foundation

// Instead of writing both Encodable and Decodable we can just write Coadable

class item: Encodable,Decodable {
    
    
    var title: String = ""
    var done: Bool = false
    
}
