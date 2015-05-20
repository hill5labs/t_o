//
//  FlashcardListTableViewController.swift
//  flashcards
//
//  Created by text_owls on 4/19/15.
//  Copyright (c) 2015 text_owls. All rights reserved.
//

import UIKit

//MARK: Bogus classes



//MARK: Controller start

class FlashcardListTableViewController: UITableViewController {

    var currentCategory: WordCategory?
    
    @IBOutlet weak var selectUIBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var deleteUIBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var addToCategoryUIBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = currentCategory!.title
        currentCategory!.getWords(from: persistantData!.wordList!)
    }
    
    override func viewDidAppear(animated: Bool) {
        showTableView()
    }

    
    func showTableView(){
        tableView.reloadData()
        tableView.allowsMultipleSelectionDuringEditing = true
        showToolbarButtons(false)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCategory!.wordCount
    }

    private struct Storyboard {
        static let CellReuseIdentifier = "Flashcard"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        println("\(indexPath.row)")
        println("\(currentCategory!.wordCount)")
        let curWord = currentCategory!.wordArray[indexPath.row]
        cell.textLabel?.text = curWord.word
        cell.detailTextLabel?.text = curWord.information.definition

        return cell
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "showSingleCard" {
            if !tableView.editing {
                return true
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (!tableView.editing) {
            if let scvc = segue.destinationViewController as? SingleCardViewController {
                if let selectedIndexPath = self.tableView.indexPathForSelectedRow() {
                    scvc.currentCategory = self.currentCategory
                    scvc.currentFlashcardNumber = selectedIndexPath.row
                }
            }
        }
    }
    
    @IBAction func toEditMode(sender: UIBarButtonItem) {
        toggleEdit()
    }
    
    func toggleEdit(){
        tableView.editing = !tableView.editing
        if tableView.editing {
            selectUIBarButtonItem.title!="Cancel"
            showToolbarButtons(true)
        } else {
            selectUIBarButtonItem.title!="Select"
            showToolbarButtons(false)
        }
    }
    
    @IBAction func deleteSelectedRows(sender: UIBarButtonItem) {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows(){
            for path in selectedIndexPaths {
                currentCategory!.wordArray[path.row].removeFromCategory(currentCategory!.title!)
            }
            currentCategory!.getWords(from: persistantData!.wordList!)
            showTableView()
            toggleEdit()
        }
    }
    
    // MARK: add to category
    
    @IBAction func addSelectedRows(sender: UIBarButtonItem) {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows(){
            var inputTextField = UITextField()
            let alertController = UIAlertController(title: "Enter category name or select a category below", message: "", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            for item in persistantData!.wordList!.getCategories() {
                if find(allBooks.titleList(), item.title!) == nil {
                    alertController.addAction(UIAlertAction(title: item.title!, style: UIAlertActionStyle.Default) { action -> Void in
                        print(item.title!)
                        for path in selectedIndexPaths {
                            self.currentCategory!.wordArray[path.row].addToCategory(item.title!)
                        }
                        self.showTableView()
                        self.toggleEdit()
                    })
                }
            }
            
            alertController.addAction(UIAlertAction(title: "Enter", style: UIAlertActionStyle.Default) { action -> Void in
                print(inputTextField.text)
                for path in selectedIndexPaths {
                    self.currentCategory!.wordArray[path.row].addToCategory(inputTextField.text)
                }
                self.showTableView()
                self.toggleEdit()
            })
            
            alertController.addTextFieldWithConfigurationHandler{ textField -> Void in inputTextField = textField }
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func showToolbarButtons(show: Bool){
        if show {
            self.deleteUIBarButtonItem.enabled=true
            self.deleteUIBarButtonItem.tintColor=UIColor.redColor()
            self.addToCategoryUIBarButtonItem.enabled=true
            self.addToCategoryUIBarButtonItem.tintColor=UIColor.blackColor()
        } else {
            self.deleteUIBarButtonItem.enabled = false
            self.deleteUIBarButtonItem.tintColor = UIColor.clearColor()
            self.addToCategoryUIBarButtonItem.enabled=false
            self.addToCategoryUIBarButtonItem.tintColor=UIColor.clearColor()
        }
    }
}
