//
//  BookMarksURL.swift
//  web
//
//  Created by kevinhe on 2019/11/28.
//  Copyright © 2019 kevinhe. All rights reserved.
//

import UIKit

struct BookMarks: Codable {
    var titles = [String]()
    var urls = [String]()

    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var numberOfBookMarks: Int {
        return urls.count
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(BookMarks.self, from: json)  {
            self = newValue
        }
    }
    init() {
        titles = []
        urls = []
    }
}
