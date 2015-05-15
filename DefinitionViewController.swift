//
//  DefinitionViewController.swift
//  ThePage
//
//  Created by Thomas Lippert on 5/4/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

import UIKit

class DefinitionViewController: UITableViewController {
    
    var currentCategory: WordCategory?
    var storedWordCategory: WordCategory?
    
    override func viewWillAppear(animated: Bool) {
        currentCategory!.getWords(from: definitionList)
    }
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentCategory!.wordCount
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("definitionCell", forIndexPath: indexPath) as! DefintionCell
        let curWord = currentCategory!.wordArray[currentCategory!.wordCount - indexPath.row - 1] //Display newer words (near end of array) at top of table
        cell.word.text = curWord.word
        cell.definition.text = curWord.information.definition
        cell.isFlashcardSwitch.tag = indexPath.item
        cell.isFlashcardSwitch.addTarget(self, action: "flashCardToggled:", forControlEvents: UIControlEvents.ValueChanged)
        if let wordMatch = storedWordCategory!.wordArray.filter({$0.word == curWord.word}).first {
            cell.isFlashcardSwitch.on = true
        } else {
            cell.isFlashcardSwitch.on = false
        }
        

        return cell
    }
    
    func flashCardToggled(mySwitch: UISwitch) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: mySwitch.tag, inSection: 0)) as! DefintionCell
        if mySwitch.on {
            wordList.addWord(cell.word.text!, newCategory: storedWordCategory!.title)
            storedWordCategory!.getWords(from: wordList)
        } else {
            if let wordMatch = wordList.allWords.filter({$0.word == cell.word.text}).first {
                wordMatch.removeFromCategory(storedWordCategory!.title!)
                storedWordCategory!.getWords(from: wordList)
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            currentCategory!.wordArray[currentCategory!.wordCount - indexPath.row - 1].removeFromCategory(currentCategory!.title!)
            currentCategory!.getWords(from: definitionList)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }

}
