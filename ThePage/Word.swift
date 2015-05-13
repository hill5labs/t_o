//
//  Word.swift
//  ThePage
//
//  Created by Thomas Lippert on 5/12/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

class Word: NSObject {

    var word: String
    var information: LexicalData
    var categoryArray = [String]()
    
    init(wordWord: String, info: LexicalData, categories: [String]){
        word = wordWord
        information = info
        categoryArray = categories
    }
    
    func removeFromCategory(targetCategory: String!){
        if let index = find(categoryArray, targetCategory){
            categoryArray.removeAtIndex(index)
            //TODO: write to file to permanently remove
            if categoryArray.count == 0 {
                wordList.removeWord(self)
            }
        }
    }
    
    func addToCategory(targetCategory: String) {
        if (find(categoryArray, targetCategory) == nil) {
            categoryArray.append(targetCategory)
            //TODO: MODIFY FILE ACCORDINGLY
        }
    }
}
