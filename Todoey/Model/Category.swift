//
//  Category.swift
//  Todoey
//
//  Created by Oybek on 2/14/21.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
