//
//  DefinitionViewController.swift
//  ThePage
//
//  Created by Thomas Lippert on 5/4/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

import UIKit

class DefinitionViewController: UITableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("definitionCell", forIndexPath: indexPath) as! DefintionCell
        switch indexPath.row {
        case 0:
            cell.word.text = "ha·bit·u·ate"
            cell.definition.text = "verb\nmake or become accustomed or used to something."
            cell.isFlashcardSwitch.on = true
        case 1:
            cell.word.text = "i·ras·ci·ble"
            cell.definition.text = "adjective\nhaving or showing a tendency to be easily angered."
            cell.isFlashcardSwitch.on = false
        case 2:
            cell.word.text = "vir·tue"
            cell.definition.text = "noun\nbehavior showing high moral standards."
            cell.isFlashcardSwitch.on = true
        case 3:
            cell.word.text = "fix·i·ty"
            cell.definition.text = "noun\nthe state of being unchanging or permanent."
            cell.isFlashcardSwitch.on = false
        case 4:
            cell.word.text = "im·per·cep·ti·ble"
            cell.definition.text = "adjective\nimpossible to perceive."
            cell.isFlashcardSwitch.on = true
        case 5:
            cell.word.text = "health"
            cell.definition.text = "noun\nthe state of being free from illness or injury."
            cell.isFlashcardSwitch.on = false
        case 6:
            cell.word.text = "art"
            cell.definition.text = "noun\nthe various branches of creative activity, such as painting, music, literature, and dance."
            cell.isFlashcardSwitch.on = true
        default:
            break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }

}
