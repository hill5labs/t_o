//
//  CompleteWordList.swift
//  ThePage
//
//  Created by Thomas Lippert on 5/12/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

import Foundation

class CompleteWordList: NSObject, NSXMLParserDelegate, NSCoding {
    //Will eventually read in from a local file, forming a full, comprehensive list of cards
    var allWords = [Word]()
    
    private var definition: NSMutableString = ""
    private var partOfSpeech: NSMutableString = ""
    private var element: String?
    private var shouldGetDefinition: Bool? //XML Flag
    private var definitionCount: Int = 0  //XML Flag
    private var wordParsing: NSMutableString = ""
    private var createdCategory = [String]()
    var parser: NSXMLParser = NSXMLParser()
    
    
    override init() {
        super.init()
//        /*Until EOF
//        parse through card in file
//        var word = stuff
//        var definition = stuff
//        var categories = [String]()
//        parse through categories
//        categories.append(stuff)
//        var card = flashcard(cardWord: word, cardDefinition: definition, cardCategories: categories)
//        allFlashcards.append(card)*/
    }
    
    //MARK: NSCoding
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.allWords = decoder.decodeObjectForKey("allWords") as! [Word]

    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(allWords, forKey: "allWords")

    }
    
    func addWord(newWordWord: String? = nil, newCategory: String? = nil, word duplicateWord: Word? = nil) {
        
        if duplicateWord != nil {
            allWords.append(duplicateWord!)
            return
        }
       
        if let wordMatch = allWords.filter({$0.word == newWordWord}).first {
            //Get index for word match?
            wordMatch.addToCategory(newCategory!)
             
            removeWord(wordMatch)
            addWord(word: wordMatch)
            
        } else {
            createdCategory.append(newCategory!)
            let encodedWord = newWordWord!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            var getDefinitionURLString = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/\(newWordWord!)?key=f0badceb-3a32-4c12-8f98-09fe6388223e"
            var url = NSURL(string: getDefinitionURLString)!
            self.parser = NSXMLParser(contentsOfURL: url)!
            self.shouldGetDefinition = true
            self.parser.delegate = self
            self.parser.parse()

        }
    }
    
    func removeWord(targetWord: Word) {
        if let index = find(allWords,targetWord) {
            allWords.removeAtIndex(index)
        }
    }
    
    // Adam added this
    func getCategories() -> [WordCategory] {
        var categories = [String]()
        var categoryList = [WordCategory]()
        for word in allWords {
            for category in word.categoryArray {
                if find(categories, category) == nil {
                    categories.append(category)
                }
            }
        }
        for item in categories {
            categoryList.append(WordCategory(categoryTitle: item, _for: self))
        }
        return categoryList
    }
    
    //MARK: NSXMLParserDelegate Methods

    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        println("Element begin")
        
        element = elementName
        
        if element == "entry" {
            partOfSpeech = ""
            definition = ""
            wordParsing = ""
            definitionCount = 0
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        println("Characters found")
        
        if element == "ew" && shouldGetDefinition! {
            
            wordParsing.appendString(string!)
        }
        
        else if element == "fl" && shouldGetDefinition! {
        
            partOfSpeech.appendString(string!)
        }
        
        else if element == "dt" && shouldGetDefinition! && (definitionCount < 3){     //Only get first three definitions
            var appendation: String?
            if definitionCount == 0 {
                appendation = "1. "
            } else {
                appendation = "\n\(definitionCount+1). "
            }
            
            let fancyDefinition = string!.stringByReplacingOccurrencesOfString(":", withString: "")
            
            //If string is whitespace
                //Decrement definitionCount
            //else
            
            if fancyDefinition.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
                //do nothing
            } else {
                definition.appendString(appendation! + fancyDefinition)
                ++definitionCount
            }
        }
        
        else if element == "fw" && shouldGetDefinition! && (definitionCount<3){
            definition.appendString(string!.stringByReplacingOccurrencesOfString(":", withString: ""))
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        println("Element ended")

        if elementName == "entry" && shouldGetDefinition! {
            println("Create word")
            shouldGetDefinition! = false
            var newWord = wordParsing as String
            allWords.append(Word(wordWord: newWord, info: LexicalData(pos: String(self.partOfSpeech), def: String(self.definition) ), categories: self.createdCategory))
            println("Done with word")
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        println("Done parsing")
    }
}

//var wordList = CompleteWordList()
//var definitionList = CompleteWordList()