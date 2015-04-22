//
//  PageViewController.swift
//  ThePage
//
//  Created by Thomas Lippert on 4/21/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, KFEpubControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var page: UIWebView!
    @IBOutlet var rightGestureRecognizer: UISwipeGestureRecognizer?
    @IBOutlet var leftGestureRecognizer: UISwipeGestureRecognizer?
    
    var epubController: KFEpubController
    var contentModel: KFEpubContentModel
    
    var spineIndex: Int = 0
    

    
    //MARK: Initialization
    
    init() {
        
        self.rightGestureRecognizer = UISwipeGestureRecognizer(target: self.page, action: Selector("didSwipeRight:"))
        self.rightGestureRecognizer?.direction = .Right
        
        self.leftGestureRecognizer  = UISwipeGestureRecognizer(target: self.page, action: Selector("didSwipeLeft:"))
        self.leftGestureRecognizer?.direction = .Left
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
    }

    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let epubURL = NSBundle.mainBundle().URLForResource("tolstoy-war-and-peace", withExtension: "epub") as NSURL!
        
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentURL = paths[0] as! NSURL
        
        self.epubController = KFEpubController(epubURL: epubURL, andDestinationFolder: documentURL)
        self.epubController.openAsynchronous(true)
        

        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: KFEpubControllerDelegate methods
    
    func epubController(controller: KFEpubController!, didFailWithError error: NSError!) {
        
        println(error)
    }
    
    func epubController(controller: KFEpubController!, willOpenEpub epubURL: NSURL!) {
        <#code#>
    }
    
    func epubController(controller: KFEpubController!, didOpenEpub contentModel: KFEpubContentModel!) {
        println("will open!")
    }
    
    
    //MARK: Handle Swipes and GestureRecognizerDelegate
    
    func didSwipeRight()
    {
        if (self.spineIndex > 1) {
            self.spineIndex--
            self.updateContentForSpineIndex(self.spineIndex)
        }
    }
    
    func didSwipeLeft() {
        if (self.spineIndex < self.contentModel.spine.count) {
            self.spineIndex++;
            self.updateContentForSpineIndex(self.spineIndex)
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: Update Swipe Index
    func updateContentForSpineIndex(currentSpineIndex: Int)
    {
        contentFile = self.contentModel.manifest(self.contentModel.spine[currentSpineIndex])
        
        
        NSString *contentFile = self.contentModel.manifest[self.contentModel.spine[currentSpineIndex]][@"href"];
        NSURL *contentURL = [self.epubController.epubContentBaseURL URLByAppendingPathComponent:contentFile];
        NSLog(@"content URL :%@", contentURL);
    
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:contentURL];
        [self.webView loadRequest:request];
        
        contentFile = self.c
    }
    
}
