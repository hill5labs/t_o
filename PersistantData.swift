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
    var pageDataList: [PersistantPage]?
    
    
    override init() {
        
        wordList = CompleteWordList()
        definitionList = CompleteWordList()
        self.pageDataList = [PersistantPage]()
    }
    
    required convenience init(coder: NSCoder) {
        self.init()
        
        self.wordList = coder.decodeObjectForKey("wordList") as? CompleteWordList
        self.definitionList = coder.decodeObjectForKey("definitionList") as? CompleteWordList
        self.pageDataList = coder.decodeObjectForKey("pageDataList") as? [PersistantPage]
        
        if self.wordList == nil {
            self.wordList = CompleteWordList()
        }
        if self.definitionList == nil {
            self.definitionList = CompleteWordList()
        }
        
        if self.pageDataList == nil {
            self.pageDataList = [PersistantPage]()
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.wordList!, forKey: "wordList")
        aCoder.encodeObject(self.definitionList!, forKey: "definitionList")
        aCoder.encodeObject(self.pageDataList!, forKey: "pageDataList")
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


class PersistantPage: NSObject, NSCoding {
    
    var title: String = ""
    var index: Int = 1
    var cPage: Int = 0
    
    override init() {
        title = ""
    }
    
    init(newTitle: String) {

        title = newTitle
    }
    
    required convenience init(coder: NSCoder) {
        self.init()
        
        self.title = coder.decodeObjectForKey("pTitle") as! String
        self.index = coder.decodeObjectForKey("pIndex") as! Int
        self.cPage = coder.decodeObjectForKey("pPage") as! Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "pTitle")
        aCoder.encodeObject(self.index, forKey: "pIndex")
        aCoder.encodeObject(self.cPage, forKey: "pPage")
    }
    
}