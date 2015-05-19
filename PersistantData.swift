//
//  PersistantData.swift
//  ThePage
//
//  Created by Thomas Lippert on 5/18/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

import UIKit

class PersistantData: NSObject, NSCoding {
    var wordList: CompleteWordList?
    var definitionList: CompleteWordList?
    
    override init() {
        
        wordList = CompleteWordList()
        definitionList = CompleteWordList()
    }
    
    required convenience init(coder: NSCoder) {
        self.init()
        
        self.wordList = coder.decodeObjectForKey("wordList") as? CompleteWordList
        self.definitionList = coder.decodeObjectForKey("definitionList") as? CompleteWordList
        
        if self.wordList == nil {
            self.wordList = CompleteWordList()
        }
        if self.definitionList == nil {
            self.definitionList = CompleteWordList()
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.wordList!, forKey: "wordList")
        aCoder.encodeObject(self.definitionList!, forKey: "definitionList")
    }
}

extension NSCoder {
    class func empty() -> NSCoder {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.finishEncoding()
        return NSKeyedUnarchiver(forReadingWithData: data)
    }
}

var persistantData: PersistantData?