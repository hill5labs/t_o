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
    
    override func viewWillAppear(animated: Bool) {
        currentCategory!.getWords()
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
        cell.isFlashcardSwitch.on = true

        return cell
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
            currentCategory!.getWords()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }

}
