//
//  TimeModel.swift
//  timer
//
//  Created by kevinhe on 2019/11/10.
//  Copyright © 2019 kevinhe. All rights reserved.
//

import UIKit

struct TimeModels: Codable {
    
    var timeModels = [TimeModel]()
    
    var fileURL: URL?
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(TimeModels.self, from: json)  {
            self = newValue
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init() {
        timeModels = []
    }
    
}


struct TimeModel: Codable {
    
    var records = [String]()
    var story = [Story]()
    var fileURL: URL?
//    var weekday = [String]()
    
    
    
    var numbersOfrecords: Int {
        return records.count
    }
    
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(TimeModel.self, from: json)  {
            self = newValue
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init() {
        records = []
    }
    
    
}
