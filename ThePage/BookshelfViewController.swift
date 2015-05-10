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
    let bookshelfName : String
    let books: [Book]
}

class Book : Equatable {
    var title: String
    var bookCover: UIImage
    
    init (title: String, image: UIImage) {
        self.title = title
        self.bookCover = image
    }
    
}

func == (lhs: Book, rhs: Book) -> Bool {
    return lhs.title == rhs.title
}


let BookList = Array(map(1..<50) {"B\($0)"})
let FlashcardList = Array(map(1..<100) {"F\($0)"})
let image: UIImage = UIImage(named:"@public@vhost@g@gutenberg@html@files@48836@48836-h@images@i_000.jpg")!
let atitle: String = "Across the Reef"



class BookshelfViewController: UICollectionViewController {
    
    private let reuseIdentifier = "BookCell"
    private let sectionInsets = UIEdgeInsets(top: 30.0, left: 30.0, bottom: 30.0, right: 30.0)
    
    @IBOutlet weak var BFToggle: UIBarButtonItem!
    
    private var searches = [Bookshelf]()
    
    static func convertToShelf(itemNameList: [String], titleName: String) -> Bookshelf {
        let newBooks : [Book] = itemNameList.map {
            item in
            
            
            let book = Book(title: atitle, image: image)
            return book
        }
            return Bookshelf(bookshelfName: titleName, books: newBooks)
    }
    
    private let myBooks = BookshelfViewController.convertToShelf(BookList, titleName: "myBooks")
    
    private let myFlashcards = BookshelfViewController.convertToShelf(FlashcardList, titleName: "myFlashcards")
    
    
    
    func drawCellObjects(currentShelf: Bookshelf) {
        self.searches.removeAll(keepCapacity: true)
        self.searches.insert(currentShelf, atIndex: 0)
        self.collectionView?.reloadData()
    }
    
    func bookForIndexPath(indexPath: NSIndexPath) -> Book {
        return searches[indexPath.section].books[indexPath.row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(BookList)
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
        return searches[section].books.count
    }
    
    override func  collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BookCell
        let book = bookForIndexPath(indexPath)
        cell.backgroundColor = UIColor.whiteColor()
        cell.bookCover.image = book.bookCover
        cell.bookTitle.text = book.title
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

//MARK: segue
































