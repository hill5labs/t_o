//
//  Word.swift
//  ThePage
//
//  Created by Thomas Lippert on 5/12/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

class Word: NSObject, NSCoding {

    var word: String
    var information: LexicalData
    var categoryArray = [String]()
    
    override init() {
        
        word = String()
        information = LexicalData(pos: "Undefined", def: "Undefined")
    }
    
    init(wordWord: String, info: LexicalData, categories: [String]){
        
        word = wordWord
        information = info
        categoryArray = categories
    }
    
    func removeFromCategory(targetCategory: String){
        
        if let index = find(categoryArray, targetCategory){
            categoryArray.removeAtIndex(index)
            //TODO: write to file to permanently remove
            if categoryArray.count == 0 {
                persistantData!.wordList!.removeWord(self)
            }
        }
    }
    
    func addToCategory(targetCategory: String) {
        
        if (find(categoryArray, targetCategory) == nil) {
            categoryArray.append(targetCategory)
            //TODO: MODIFY FILE ACCORDINGLY
        }
    }
    
    required convenience init(coder decoder: NSCoder) {
        
        self.init()
        var tWord = decoder.decodeObjectForKey("word") as? String
        var tInfo = decoder.decodeObjectForKey("information") as? LexicalData
        var tCatArr = decoder.decodeObjectForKey("categoryArray") as? [String]
        
        if tWord != nil {
            word = tWord!
        }
        
        if tInfo != nil {
            information = tInfo!
        }
        
        if tCatArr != nil {
            categoryArray = tCatArr!
        }
    }
    
    func encodeWithCoder(coder: NSCoder) {

        coder.encodeObject(word, forKey: "word")
        coder.encodeObject(information, forKey: "information")
        coder.encodeObject(categoryArray, forKey: "categoryArray")
    }
}
