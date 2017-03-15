//
//  Person.swift
//  StarWars
//
//  Created by Aaron Rogers on 3/15/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import RealmSwift

class Person: Object {
    dynamic var id = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var birthDate = Date.init(timeIntervalSince1970: 1)
    dynamic var profilePicture = ""
    dynamic var forceSensitive = false
    dynamic var affiliation = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
