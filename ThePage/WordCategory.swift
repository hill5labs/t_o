//
//  WordCategory.swift
//  ThePage
//
//  Created by Thomas Lippert on 5/12/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

class WordCategory: NSObject {
    
    var title: String?
    var wordCount: Int = 0
    var wordArray = [Word]()
        
    init(categoryTitle: String){
        super.init()
        title=categoryTitle
        getWords()
    }
        
    func getWords(){
        wordArray.removeAll(keepCapacity: false)
        for thisWord in wordList.allWords {
            if let index = find(thisWord.categoryArray, title!) {
                wordArray.append(thisWord)
            }
        }
        wordCount=wordArray.count
    }
}

