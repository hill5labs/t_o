//
//  DefinitionViewController.swift
//  ThePage
//
//  Created by Thomas Lippert on 5/4/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

import UIKit

class DefinitionViewController: UITableViewController {
    var theSupremeButt: CGFloat = 150
    var samsButt: CGFloat = 0
    var supremeButtIndexPath: NSIndexPath?
    var currentCategory: WordCategory?
    var storedWordCategory: WordCategory?
    
    override func viewWillAppear(animated: Bool) {
        currentCategory!.getWords(from: persistantData!.definitionList!)
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
        cell.partOfSpeechLabel.text = curWord.information.partOfSpeech
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
            if let wordMatch = persistantData!.definitionList!.allWords.filter({$0.word == cell.word.text}).first {
                persistantData!.wordList!.addWord(word: wordMatch)
                storedWordCategory!.getWords(from: persistantData!.wordList!)
            }
        } else {
            if let wordMatch = persistantData!.wordList!.allWords.filter({$0.word == cell.word.text}).first {
                wordMatch.removeFromCategory(storedWordCategory!.title!)
                storedWordCategory!.getWords(from: persistantData!.wordList!)
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == supremeButtIndexPath {
            return self.theSupremeButt
        }
        
        return 150
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            self.currentCategory!.wordArray[currentCategory!.wordCount - indexPath.row - 1].removeFromCategory(currentCategory!.title!)
            self.currentCategory!.getWords(from: persistantData!.definitionList!)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath != supremeButtIndexPath {
            var cell = self.tableView.cellForRowAtIndexPath(indexPath) as! DefintionCell
            self.tableView.beginUpdates()
            let fixedWidth:CGFloat = cell.definition.frame.width
            let myButt = cell.definition.frame.height
            let newSize = cell.definition.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
            var newFrame = cell.definition.frame
            newFrame.size = CGSize(width: fmax(newSize.width, fixedWidth), height: CGFloat(newSize.height))
            cell.definition.frame = newFrame
        
            samsButt = cell.definition.frame.height
            theSupremeButt = samsButt - myButt + 150
            supremeButtIndexPath = indexPath

            self.tableView.endUpdates()
            cell.definition.frame=newFrame
        }
    }
}
