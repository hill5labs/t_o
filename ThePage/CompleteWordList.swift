//
//  CompleteWordList.swift
//  ThePage
//
//  Created by Thomas Lippert on 5/12/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

import Foundation

struct CompleteWordList {
    //Will eventually read in from a local file, forming a full, comprehensive list of cards
    var allWords = [Word]()
    init(){
        /*Until EOF
        parse through card in file
        var word = stuff
        var definition = stuff
        var categories = [String]()
        parse through categories
        categories.append(stuff)
        var card = flashcard(cardWord: word, cardDefinition: definition, cardCategories: categories)
        allFlashcards.append(card)*/
            
        //For now, we'll just generate some cards with the same category
 //       var category = [String]()
   //     category.append("Nicomachean Ethics")
//        var fucksCard = Word(wordWord: "Zero" , info: LexicalData(pos: "noun", def: "The amount of fucks I give right now"), categories: category)
   //     var irascible = Word(wordWord: "irascible", info: LexicalData(pos:"adjective", def: "Having or showing a tendency to be easily angered"), categories: category)
  //      allWords.append(irascible)
//        allWords.append(fucksCard)
    }
    
    mutating func addWord(newWordWord: String, newCategory: String) {
        
        if let wordMatch = allWords.filter({$0.word == newWordWord}).first {
            //Get index for word match?
            if find(wordMatch.categoryArray, newCategory) == nil {
                wordMatch.addToCategory(newCategory)
            }
        } else {
            var createdCategory = [String]()
            createdCategory.append(newCategory)
            
            //TODO: Fetch and create lexical data
            var createdWord = Word(wordWord: newWordWord, info: LexicalData(pos: "Undefined", def: "Undefined"), categories: createdCategory)
            allWords.append(createdWord)
        }
    }
    
    mutating func removeWord(targetWord: Word) {
        if let index = find(allWords,targetWord) {
            allWords.removeAtIndex(index)
        }
    }
}

var wordList = CompleteWordList()