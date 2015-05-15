//
//  PageViewController.swift
//  ThePage
//
//  Created by Thomas Lippert on 4/21/15.
//  Copyright (c) 2015 Hill 5 Labs. All rights reserved.
//

import UIKit


class PageViewController: UIViewController, UIGestureRecognizerDelegate, UIWebViewDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var page: UIWebView!
    @IBOutlet weak var pageContainer: UIView!
    @IBOutlet var rightSwipeRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var leftSwipeRecognizer: UISwipeGestureRecognizer!
    
    var dvc: DefinitionViewController?
    
    var epubController: KFEpubController?
    var contentModel: KFEpubContentModel?

    var spineIndex: Int = 2
    var toLastPage = false
    
    var book: Book?

    var debug: NSURL?
    //MARK: View Lifecycle
        
    private let js01 = "var p = document.getElementsByTagName('p');"
    private let js02 = "for (var i=0; i<p.length; ++i){p[i].innerHTML=p[i].innerText.replace(/\\b(\\w+?)\\b/g, function(word){return \"<span onclick='window.location.href=\\\"alert://\" + word + \"\\\"'>\" + word + \"</span>\";});}"
    private let js03 = "document.body.innerHTML"
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        
        epubController = book!.epubController
        contentModel = book!.contentModel
        updateContentForSpineIndex(spineIndex)
        
        self.title = book!.title
        
        
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
        } else if gestureRecognizer.direction == .Left && cPage < contentModel?.spine.count  {
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
        var contentURL = epubController!.epubContentBaseURL.URLByAppendingPathComponent(contentFile) as NSURL
        println("content URL: \(contentURL)")
        var request = NSURLRequest(URL: contentURL)
        page.loadRequest(request)
    }
    
    func getCurrentPage() -> Int {
        let width: CGFloat = page.scrollView.frame.size.width
        let currentPage: NSInteger = NSInteger((page.scrollView.contentOffset.x + (0.5 * width)) / width)
        return currentPage
    }
    
    //MARK: Utility and navigation functions
    
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
        let try01 = page.stringByEvaluatingJavaScriptFromString(js01)
        let try02 = page.stringByEvaluatingJavaScriptFromString(js02)
        let try03 = page.stringByEvaluatingJavaScriptFromString(js03)

        var latestPage = self.page.request!.URL!.absoluteString?.lastPathComponent
        var currentSection = latestPage!.stringByDeletingPathExtension
        var swiftArray = contentModel!.spine as! [String]
        spineIndex = find(swiftArray, currentSection)!
        println("Loading complete")
        if toLastPage {
            scrollToPage(page.pageCount-1, animated: false)
            toLastPage = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueName = segue.identifier
        if segueName == "embedDefinitionController" {
            dvc = segue.destinationViewController as? DefinitionViewController
            dvc?.currentCategory = WordCategory(categoryTitle: book!.title!, _for: definitionList)
            dvc?.storedWordCategory = WordCategory(categoryTitle: book!.title!, _for: wordList)
        }
    }
    
//    MARK: Javascript alert intercept
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch (navigationType) {
        case UIWebViewNavigationType.Other:
            if request.URL?.scheme == "alert" {
                let message = request.URL?.host
                println("Word clicked: \(message)")
                let defineWord = message!.lowercaseString
                definitionList.addWord(defineWord, newCategory: book!.title!)
                dvc?.currentCategory!.getWords(from: definitionList)
                dvc?.tableView.reloadData()
                return false
            }
            return true
        default:
            return true
        }
    }
}
