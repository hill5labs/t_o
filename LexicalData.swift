//
//  LexicalData.swift
//  ThePage
//
//  Created by Thomas Lippert on 5/12/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

class LexicalData: NSObject, NSCoding {
    var partOfSpeech: String = "undefined"
    var definition: String  = "undefined"
    
    override init() {
        
        partOfSpeech = "undefined"
        definition = "undefined"
    }
    
    init(pos: String, def: String) {
        
        partOfSpeech = pos
        definition = def
    }
    
    required convenience init(coder decoder: NSCoder) {

        self.init()
        let tPOS = decoder.decodeObjectForKey("partOfSpeech") as? String
        let tDef = decoder.decodeObjectForKey("def") as? String
        
        if tPOS != nil {
            partOfSpeech = tPOS!
        }
        
        if tDef != nil {
            definition = tDef!
        }
    }
    
    func encodeWithCoder(coder: NSCoder) {
        
        coder.encodeObject(partOfSpeech, forKey: "partOfSpeech")
        coder.encodeObject(definition, forKey: "def")
    }
}
