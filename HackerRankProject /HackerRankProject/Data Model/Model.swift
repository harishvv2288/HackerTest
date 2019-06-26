//
//  Model.swift
//  HackerRankProject
//
//  Created by Harish V V on 22/06/19.
//  Copyright © 2019 Company. All rights reserved.
//

import Foundation

///This is the Data Model class or an Entity class

struct Canada {
    var title: String?
    var jsonRows: [Any]
    var rows: [Row] = []
    
    init(dictionary: [String: Any]) {
        self.title = dictionary[IDENTIFIERS.COUNTRY_TITLE] as? String
        self.jsonRows = dictionary[IDENTIFIERS.COUNTRY_ENTITIES] as! [Any]
        
        for row in self.jsonRows {
            if let record = row as? [String: Any] {
                let rowObject = Row.init(dictionary: record)
                //check to ensure atleast one key has a non nil value associated with it
                //if all the keys in "Rows" have a nil value then do not append it to the "rows" array
                if rowObject.title.count != 0 || rowObject.description.count != 0 || rowObject.imageUrl.count != 0 {
                    self.rows.append(rowObject)
                }
            }
        }
    }
}

struct Row {
    var title: String
    var description: String
    var imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.title = dictionary[IDENTIFIERS.ENTITY_TITLE] as? String ?? ""
        self.description = dictionary[IDENTIFIERS.ENTITY_DESCRIPTION] as? String ?? ""
        self.imageUrl = dictionary[IDENTIFIERS.ENTITY_IMAGE_URL] as? String ?? ""
    }
}
