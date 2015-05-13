//
//  BookList.swift
//  ThePage
//
//  Created by Thomas Lippert on 5/13/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

import Foundation

class BookList: AnyObject {
    var list = [Book]()
    
    func append(book: Book) {
        list.append(book)
    }
}

var allBooks = BookList()
