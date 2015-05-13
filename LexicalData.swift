//
//  LexicalData.swift
//  ThePage
//
//  Created by Thomas Lippert on 5/12/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

class LexicalData: NSObject {
    var partOfSpeech: String = "undefined"
    var definition: String  = "undefined"
    
    init(pos: String, def: String) {
        
        partOfSpeech = pos
        definition = def
    }
}
