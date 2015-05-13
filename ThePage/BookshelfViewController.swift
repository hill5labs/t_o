//
//  BookshelfViewController.swift
//  TextOwl
//
//  Created by Adam Dale Carlson on 4/30/15.
//  Copyright (c) 2015 Adam Dale Carlson. All rights reserved.
//

import UIKit

//Mark: auxillary data structures

struct Bookshelf {
    let containsBooks : Bool
    let items : [AnyObject]
}

let FlashcardList = Array(map(1..<2) {"F\($0)"})
let image: UIImage = UIImage(named:"@public@vhost@g@gutenberg@html@files@48836@48836-h@images@i_000.jpg")!
let atitle: String = "Across the Reef"



class BookshelfViewController: UICollectionViewController {
    
    private let reuseIdentifier = "BookCell"
    private let sectionInsets = UIEdgeInsets(top: 30.0, left: 30.0, bottom: 30.0, right: 30.0)
    
    @IBOutlet weak var BFToggle: UIBarButtonItem!
    
    private var searches = [Bookshelf]()
    
    static func convertToShelf(itemList: [AnyObject], isBooks: Bool) -> Bookshelf {
        return Bookshelf(containsBooks: isBooks, items: itemList)
    }
    
    private let myBooks = BookshelfViewController.convertToShelf(allBooks.list, isBooks: true)
    private let myFlashcards = BookshelfViewController.convertToShelf(wordList.getCategories(), isBooks: false)
    
    
    func drawCellObjects(currentShelf: Bookshelf) {
        self.searches.removeAll(keepCapacity: true)
        self.searches.insert(currentShelf, atIndex: 0)
        self.collectionView?.reloadData()
    }
    
    func itemForIndexPath(indexPath: NSIndexPath) -> AnyObject {
        return searches[indexPath.section].items[indexPath.row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(allBooks.list)
        drawCellObjects(self.myBooks)
    }
    
    @IBAction func toggleBetweenBooksAndFlashcards(sender: UIBarButtonItem) {
        var nextShelf = myBooks
        if BFToggle.title == "Books" {
            BFToggle.title = "Flashcards"
        }
        else {
            BFToggle.title = "Books"
            nextShelf = myFlashcards
        }
        
        drawCellObjects(nextShelf)
        
    }
}


extension BookshelfViewController : UICollectionViewDataSource {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].items.count
    }
    
     override func  collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BookCell
        cell.backgroundColor = UIColor.whiteColor()
        
        let item: AnyObject = itemForIndexPath(indexPath)
        
        if item is Book {
            let book = item as! Book
            cell.bookCover.image = book.img
            cell.bookTitle.text = book.title
            
            if let viewWithTag = cell.bookCover.viewWithTag(1) {
                viewWithTag.removeFromSuperview()
            }
            
        } else {
            let flashcard = item as! WordCategory
            cell.bookCover.image = flashcard.img
            cell.bookTitle.text = flashcard.title
            
            var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
            visualEffectView.frame = cell.bookCover.bounds
            visualEffectView.tag = 1
            
            var numOfFlashcards = UILabel(frame: cell.bookCover.frame)
            numOfFlashcards.textAlignment = NSTextAlignment.Center
            numOfFlashcards.text = String(flashcard.wordCount)
            
            visualEffectView.addSubview(numOfFlashcards)
            cell.bookCover.addSubview(visualEffectView)
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(BFToggle.title == "Books") {
            performSegueWithIdentifier("ToFlashCards", sender: self)
        } else {
            performSegueWithIdentifier("ToPages", sender: self)
        }

    }
}


extension BookshelfViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 150, height: 230)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}