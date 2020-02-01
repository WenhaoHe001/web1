//
//  Story.swift
//  timer
//
//  Created by kevinhe on 2019/11/13.
//  Copyright © 2019 kevinhe. All rights reserved.
//

import Foundation

struct Story: Codable {
    
    var story: String?
    var weekday: Weekday?
    var mood: Mood?
//    var datas: [Data]?
    var dataInfo: [DataInfo]?
    
    struct DataInfo: Codable {
        let x: Int?
        let y: Int?
        let data: Data?
        let width: Int?
        let height: Int?
    }
    
    
    enum Weekday: String, Codable {
        case Monday = "Monday"
        case Tuesday = "Tuesday"
        case Wednesday = "Wednesday"
        case Thurday = "Thurday"
        case Friday = "Friday"
        case Saturday = "Saturday"
        case Sunday = "Sunday"
        
        static var All = [Weekday.Monday, .Tuesday, .Wednesday, .Thurday, .Friday, .Saturday, .Sunday]
    }
    
    enum Mood: String, Codable {
        case good
        case bad
        case normal
        case other
        
        static var All = [Mood.good, .bad, .normal, .other]
    }
    
//    init?(story: String, datas: [DataInfo]) {
//        self.story = story
//        self.dataInfo = datas
//    }
}
