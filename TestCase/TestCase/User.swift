//
//  User.swift
//  TestCase
//
//  Created by Omar Al tawashi on 5/7/19.
//  Copyright © 2019 TestCase. All rights reserved.
//

import Foundation


class User : NSObject, NSCoding {
    
    var name: String
    var bot: String
    var _id: String
    
    // Normal initializer
    init(name: String, _id: String,bot:String) {
        self.name = name
        self._id = _id
        self.bot = bot
    }
    
   
    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        guard let bot = decoder.decodeObject(forKey: "bot") as? String
            else { return nil }
        guard let name = decoder.decodeObject(forKey: "name") as? String
            else { return nil }
        guard let _id = decoder.decodeObject(forKey: "_id") as? String
            else { return nil }
        self.init(
            name: name,
            _id: _id,bot:bot)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self._id, forKey: "_id")
        aCoder.encode(self.bot, forKey: "bot")
    }
    
    
}
