//
//  PageViewController.swift
//  ThePage
//
//  Created by Thomas Lippert on 4/21/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, KFEpubControllerDelegate, UIGestureRecognizerDelegate, UIWebViewDelegate {
    
    
    //MARK: Properties
    
    @IBOutlet weak var page: UIWebView!
    @IBOutlet weak var pageContainer: UIView!
    @IBOutlet var rightSwipeRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var leftSwipeRecognizer: UISwipeGestureRecognizer!
    
    var epubController: KFEpubController?
    var contentModel: KFEpubContentModel?

    var spineIndex: Int = 0
    var toLastPage = false

    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let bundle = NSBundle.mainBundle() as NSBundle
        let pathForEPUB = bundle.pathForResource("nicomachean", ofType: "epub") as String?
        let wapURL = NSURL(fileURLWithPath: pathForEPUB!)
        
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentURL = paths[0] as! NSURL
        
        page.delegate = self
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
        //When flicking forward to a page, the current page equals the leaving page
        //When flicking backward to a page, the current page equals the upcoming page
        //So we just add 1 to current page when flicking to the next page
        var cPage = getCurrentPage() + 1
        var count = page.pageCount
        println("Current Page = \(cPage)")
        println("Total Pages = \(count)")
        
        if gestureRecognizer.direction == .Right && spineIndex > 1 {
            if cPage == 1 {
                page.scrollView.panGestureRecognizer.enabled = false
                spineIndex--
                updateContentForSpineIndex(spineIndex)
                //We also need to go to the last page of the previous spine, so:
                toLastPage = true
                page.scrollView.panGestureRecognizer.enabled = true
            }
        } else if gestureRecognizer.direction == .Left && spineIndex < contentModel?.spine.count  {
            if (cPage == self.page.pageCount) {
                page.scrollView.panGestureRecognizer.enabled = false
                spineIndex++
                updateContentForSpineIndex(spineIndex)
                page.scrollView.panGestureRecognizer.enabled = true
            }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: EPUB contents
    
    func updateContentForSpineIndex(currentSpineIndex: Int) {
        
        let contentFile = contentModel!.manifest[contentModel!.spine[currentSpineIndex] as! String]!["href"] as! String
       //	 spineIndex = contentModel!.spine[currentSpineIndex] as! Int
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
        let width: CGFloat = page.scrollView.frame.size.width
        let currentPage: NSInteger = NSInteger((page.scrollView.contentOffset.x + (0.5 * width)) / width)
        return currentPage
    }
    
    //MARK: Navigation functions
    
    func scrollToPage(targetPage: Int, animated: Bool) {
        var frame: CGRect = page.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(targetPage)
        frame.origin.y = 0
        page.scrollView.scrollRectToVisible(frame, animated:animated)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        println("Started Loading")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        println("Loading complete")
        if toLastPage {
            scrollToPage(page.pageCount-1, animated: false)
            toLastPage = false
        }
    }

}
