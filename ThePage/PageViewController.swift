//
//  PageViewController.swift
//  ThePage
//
//  Created by Thomas Lippert on 4/21/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, KFEpubControllerDelegate, UIGestureRecognizerDelegate {
    
    
    //MARK: Properties
    
    @IBOutlet weak var page: UIWebView!

    
    var epubController: KFEpubController?
    var contentModel: KFEpubContentModel?

    var spineIndex: Int = 0

    
    //MARK: Initialization

    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        println("view did appear")
        let bundle = NSBundle.mainBundle() as NSBundle
        let pathForEPUB = bundle.pathForResource("tolstoy-war-and-peace", ofType: "epub") as String?
        let wapURL = NSURL(fileURLWithPath: pathForEPUB!)
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentURL = paths[0] as! NSURL
        epubController = KFEpubController(epubURL: wapURL!, andDestinationFolder: documentURL)
        self.epubController!.delegate = self;
        self.epubController!.openAsynchronous(true)
        
        let rightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("didSwipeRight:"))
        rightGestureRecognizer.direction = .Right
        
        page.addGestureRecognizer(rightGestureRecognizer)
        
        let leftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("didSwipeLeft:"))
        leftGestureRecognizer.direction = .Left
        self.page.addGestureRecognizer(rightGestureRecognizer)
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        println("view will appear")
    }
    
    override func viewDidAppear(animated: Bool) {
        
        println("view did appear")
    }
    
    //MARK: Handle Swipes and GestureRecognizerDelegate
    
    func didSwipeRight() {
        
        if (self.spineIndex > 1) {
            self.spineIndex--
            self.updateContentForSpineIndex(self.spineIndex)
        }
    }
    
    func didSwipeLeft() {
        
        if (self.spineIndex < self.contentModel!.spine.count) {
            self.spineIndex++;
            self.updateContentForSpineIndex(self.spineIndex)
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: EPUB contents
    
    func updateContentForSpineIndex(currentSpineIndex: Int) {
        
        let contentFile = self.contentModel!.manifest[self.contentModel!.spine[currentSpineIndex] as! String]!["href"] as! String
        var contentURL = self.epubController!.epubContentBaseURL.URLByAppendingPathComponent(contentFile) as NSURL
        println("content URL: \(contentURL)")
        var request = NSURLRequest(URL: contentURL)
        self.page.loadRequest(request)
    }
  
    //MARK: KFEpubControllerDelegate methods
    
    func epubController(controller: KFEpubController!, willOpenEpub epubURL: NSURL!) {
        
        println("will open EPUB")
    }
    
    func epubController(controller: KFEpubController!, didOpenEpub contentModel: KFEpubContentModel!) {
        let title = "title"
        println("Opened: \(contentModel!.metaData[title])")
        self.contentModel = contentModel
        self.spineIndex = 4
        self.updateContentForSpineIndex(self.spineIndex)
        println("will open!")
    }
    
    func epubController(controller: KFEpubController!, didFailWithError error: NSError!) {
        
        println("epubcontroller:didFailWithError: \(error.description)")
    }
    
    

    

}
