//
//  Category.swift
//  Todo App
//
//  Created by Osama Fahim on 22/06/2019.
//  Copyright © 2019 Osama Fahim. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()

}
