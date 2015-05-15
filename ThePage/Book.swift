//
//  Book.swift
//  ThePage
//
//  Created by Thomas Lippert on 5/12/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//
import UIKit


class Book: NSObject, KFEpubControllerDelegate {
    
    var title: String?
    var url: NSURL?
    var resourceName: String
    var img: UIImage?
    var contentModel: KFEpubContentModel?
    var epubController: KFEpubController?
    
    init(recName: String) {

        resourceName = recName
        
        let bundle = NSBundle.mainBundle() as NSBundle
        
        let recPrefix = resourceName.stringByDeletingPathExtension
        let pathForEPUB = bundle.pathForResource(recPrefix, ofType: "epub") as String?
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentURL = paths[0] as! NSURL
        
        url = NSURL(fileURLWithPath: pathForEPUB!)!
        
        epubController = KFEpubController(epubURL: url, andDestinationFolder: documentURL)
        super.init()
        epubController?.delegate = self
        epubController!.openAsynchronous(false)
        
        img = UIImage(named: "cover\(arc4random_uniform(5) + 2)")
    }
    
    //MARK: KFEpubControllerDelegate Methods
    func epubController(controller: KFEpubController!, didFailWithError error: NSError!) {
        println("epubcontroller:didFailWithError: \(error.description)")
    }
    
    func epubController(controller: KFEpubController!, willOpenEpub epubURL: NSURL!) {
        println("Golly, are we going to open an epub?")
    }
    
    func epubController(controller: KFEpubController!, didOpenEpub contentModel: KFEpubContentModel!) {
        let titleString = "title"
        println("Opened: \(contentModel!.metaData[titleString])")
        self.contentModel = contentModel
        title = self.contentModel!.metaData[titleString] as? String
        
    }
}
