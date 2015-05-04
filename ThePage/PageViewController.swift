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
    @IBOutlet weak var pageContainer: UIView!
    @IBOutlet var rightSwipeRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var leftSwipeRecognizer: UISwipeGestureRecognizer!
    
    var epubController: KFEpubController?
    var contentModel: KFEpubContentModel?

    var spineIndex: Int = 0

    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let bundle = NSBundle.mainBundle() as NSBundle
        let pathForEPUB = bundle.pathForResource("nicomachean", ofType: "epub") as String?
        let wapURL = NSURL(fileURLWithPath: pathForEPUB!)
        
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentURL = paths[0] as! NSURL
        
        page.scrollView.pagingEnabled = true
        page.scrollView.bounces = false
        page.paginationMode = .LeftToRight
        page.paginationBreakingMode = .Page
        page.gapBetweenPages = 0
        page.scrollView.bouncesZoom = false
        page.scrollView.maximumZoomScale = 1.0
        page.scrollView.minimumZoomScale = 1.0
        page.scalesPageToFit = false
        page.scrollView.bounces = false

        epubController = KFEpubController(epubURL: wapURL!, andDestinationFolder: documentURL)
        epubController!.delegate = self;
        epubController!.openAsynchronous(true)
        self.page.scrollView.acce
        
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("respondToSwipe:"))
        rightSwipeRecognizer.direction = .Right
        rightSwipeRecognizer.cancelsTouchesInView = false
        rightSwipeRecognizer.delegate = self
        //rightSwipeRecognizer.requireGestureRecognizerToFail(page.scrollView.panGestureRecognizer )
        self.page.addGestureRecognizer(rightSwipeRecognizer)

        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("respondToSwipe:"))
        leftSwipeRecognizer.direction = .Left
        leftSwipeRecognizer.cancelsTouchesInView = false
        leftSwipeRecognizer.delegate = self
        //leftSwipeRecognizer.requireGestureRecognizerToFail(page.scrollView.panGestureRecognizer)
        self.page.addGestureRecognizer(leftSwipeRecognizer)
    }
    
    //MARK: Handle Swipes and GestureRecognizerDelegate
    
    func respondToSwipe(gestureRecognizer: UISwipeGestureRecognizer) {
        var cPage = getCurrentPage() + 1
        var count = page.pageCount
        if gestureRecognizer.direction == .Right && spineIndex > 1 && cPage == 1 {
        
            spineIndex--
            updateContentForSpineIndex(spineIndex)
        } else if gestureRecognizer.direction == .Left && spineIndex < contentModel?.spine.count  {
            if (cPage == self.page.pageCount - 1) && veloc {
                spineIndex++
                updateContentForSpineIndex(spineIndex)
            }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: EPUB contents
    
    func updateContentForSpineIndex(currentSpineIndex: Int) {
        
        let contentFile = contentModel!.manifest[contentModel!.spine[currentSpineIndex] as! String]!["href"] as! String
        var contentURL = epubController!.epubContentBaseURL.URLByAppendingPathComponent(contentFile) as NSURL
        println("content URL: \(contentURL)")
        var request = NSURLRequest(URL: contentURL)
        page.loadRequest(request)
    }
  
    //MARK: KFEpubControllerDelegate methods
    
    func epubController(controller: KFEpubController!, willOpenEpub epubURL: NSURL!) {
        
        println("will open EPUB")
    }
    
    func epubController(controller: KFEpubController!, didOpenEpub contentModel: KFEpubContentModel!) {
        let title = "title"
        println("Opened: \(contentModel!.metaData[title])")
        self.contentModel = contentModel
        spineIndex = 4
        updateContentForSpineIndex(spineIndex)
        println("will open!")
    }
    
    func epubController(controller: KFEpubController!, didFailWithError error: NSError!) {
        
        println("epubcontroller:didFailWithError: \(error.description)")
    }
    
    func getCurrentPage() -> Int {
        let currentPage = Int(page.scrollView.contentOffset.x / page.scrollView.frame.size.width)
        return currentPage
    }
}
