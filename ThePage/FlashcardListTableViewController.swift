//
//  FlashcardListTableViewController.swift
//  flashcards
//
//  Created by text_owls on 4/19/15.
//  Copyright (c) 2015 text_owls. All rights reserved.
//

import UIKit

//MARK: Bogus classes

class flashcardCategory
{
    var title: String
    var flashcardCount: Int = 0
    var flashcardsArray = [flashcard]()
    
    var flashcardList = cardList()
    
    init(categoryTitle: String){
        title=categoryTitle
        getCards()
    }
    
    func getCards(){
        flashcardsArray.removeAll(keepCapacity: false)
        for card in flashcardList.allFlashcards {
            if let index = find(card.categoryArray, title) {
                flashcardsArray.append(card)
            }
        }
        flashcardCount=flashcardsArray.count
    }
}

class flashcard {
    var word: String
    var definition: String
    var categoryArray = [String]()
    
    init(cardWord: String, cardDefinition: String, cardCategories: [String]){
        word = cardWord
        definition = cardDefinition
        categoryArray = cardCategories
    }
    
    func removeFromCategory(targetCategory: String!){
        if let index = find(categoryArray, targetCategory){
            categoryArray.removeAtIndex(index)
            //write to file to permanently remove
        }
    }
}

class cardList {
    //Will eventually read in from a local file, forming a full, comprehensive list of cards
    var allFlashcards = [flashcard]()
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
        var category = [String]()
        category.append("Nicomachean Ethics")
        var fucksCard = flashcard(cardWord: "Zero", cardDefinition: "The amount of fucks I give right now", cardCategories: category)
        var irascible = flashcard(cardWord: "irascible", cardDefinition: "adjective\nhaving or showing a tendency to be easily angered.", cardCategories: category)
        allFlashcards.append(irascible)
        allFlashcards.append(fucksCard)
        for i in 0...24{
            var card = flashcard(cardWord: "Word \(i)", cardDefinition: "Definition number \(i)", cardCategories: category)
            allFlashcards.append(card)
        }
    }
}

//MARK: Controller start

class FlashcardListTableViewController: UITableViewController {

    var currentCategory = flashcardCategory(categoryTitle: "Nicomachean Ethics")
    
    @IBOutlet weak var selectUIBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var deleteUIBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var addToCategoryUIBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = currentCategory.title
        currentCategory.getCards()
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
        return currentCategory.flashcardCount
    }

    private struct Storyboard {
        static let CellReuseIdentifier = "Flashcard"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        println("\(indexPath.row)")
        println("\(currentCategory.flashcardCount)")
        let flashcard = currentCategory.flashcardsArray[indexPath.row]
        cell.textLabel?.text = flashcard.word
        cell.detailTextLabel?.text = flashcard.definition

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
                currentCategory.flashcardsArray[path.row].removeFromCategory(currentCategory.title)
            }
            currentCategory.getCards()
            showTableView()
            toggleEdit()
        }
    }
    
    @IBAction func addSelectedRows(sender: UIBarButtonItem) {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows(){
            //Bring up keyboard
            //Add user category to each card
            showTableView()
            toggleEdit()
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
