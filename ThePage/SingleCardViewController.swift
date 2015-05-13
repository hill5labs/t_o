//
//  SingleCardViewController.swift
//  flashcards
//
//  Created by text_owls on 4/19/15.
//  Copyright (c) 2015 text_owls. All rights reserved.
//

import UIKit

class SingleCardViewController: UIViewController {
    
    //MARK - Variable declarations
    
    var currentFlashcard: Word?    //The current flashcard displayed on the view
    var currentCategory: WordCategory? //The current category of which the current flashcard is a part
    var currentFlashcardNumber: Int = 0     //The index number of the current flashcard in the current category's flashcard array
    @IBOutlet weak var deleteUIBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var flashcardWordLabel: UILabel!
    @IBOutlet weak var flashcardDefinitionLabel: UILabel!
    @IBOutlet weak var flashcardView: UIView!
    
    private var originalBounds = CGRect.zeroRect    //Bounds for flashcardView
    private var originalCenter = CGPoint.zeroPoint  //Center point for flashcardView
    
    private var animator: UIDynamicAnimator!
    private var attachmentBehavior: UIAttachmentBehavior!
    private var pushBehavior: UIPushBehavior!
    private var gravityBehavior: UIGravityBehavior!
    private var itemBehavior: UIDynamicItemBehavior!
    
    let ThrowingThreshold: CGFloat = 1000   //Arbitrarily determined
    let ThrowingVelocityPadding: CGFloat = 35   //Arbitrarily determined

    //MARK - viewDidLoad preparation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flashcardView.center = view.center  //Autolayout doesn't work for some reason
        
        self.title = currentCategory!.title
        showCard()
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: Selector("tapped")) //Flips card
        singleTapGesture.numberOfTapsRequired = 1
        
        let panGesture = UIPanGestureRecognizer(target: self, action: Selector("panned:"))  //Swipes card
        
        flashcardView.addGestureRecognizer(singleTapGesture)
        flashcardView.addGestureRecognizer(panGesture)
        flashcardView.userInteractionEnabled = true
        
        animator = UIDynamicAnimator(referenceView: view)
        itemBehavior = UIDynamicItemBehavior(items: [flashcardView])
        itemBehavior.allowsRotation = false
        itemBehavior.friction = 0.7 //Arbitrarily determined
        
        originalBounds = flashcardView.bounds
        originalCenter = flashcardView.center
    }
    
    func showCard() {
        if currentFlashcardNumber >= currentCategory!.wordCount {  //Exception when furthest card is deleted
            currentFlashcardNumber = currentCategory!.wordCount-1
        }
        println("Current flashcard number: \(currentFlashcardNumber)")
        println("Current array size: \(currentCategory!.wordArray.count)")
        
        if currentCategory!.wordCount != 0 {
            self.currentFlashcard = currentCategory!.wordArray[currentFlashcardNumber]
        } else {        //Exception occurs when final card is deleted
            currentFlashcard = nil
        }
        
        if currentFlashcard != nil {
            flashcardWordLabel.text=currentFlashcard!.word
            flashcardWordLabel.sizeToFit()
            flashcardDefinitionLabel.text=currentFlashcard!.information.definition
            flashcardDefinitionLabel.sizeToFit()
        } else {                                    //Can occur with flashcard deletion
            flashcardWordLabel.text = "No flashcards in this category"
            flashcardDefinitionLabel.text = "No flashcards in this category"
            flashcardView.hidden = true
        }
        flashcardDefinitionLabel.hidden = true
        flashcardWordLabel.hidden = false
    }
    
    func inView(rectTarget: CGRect) -> Bool {
        let viewRect = view.frame
        
        let targetXMin = CGRectGetMinX(rectTarget)
        let targetXMax = CGRectGetMaxX(rectTarget)
        let targetYMin = CGRectGetMinY(rectTarget)
        let targetYMax = CGRectGetMaxY(rectTarget)
        
        let viewXMin = CGRectGetMinX(viewRect)
        let viewXMax = CGRectGetMaxX(viewRect)
        let viewYMin = CGRectGetMinY(viewRect)
        let viewYMax = CGRectGetMaxY(viewRect)
        
        if ( targetXMin > viewXMax || targetXMax < viewXMin ||
            targetYMin > viewYMax || targetYMax < viewYMin){
                return false
        } else {
            return true
        }
    }
    
    //MARK - Gesture handlers
    
    func tapped() {
        println("Tapped")
        UIView.transitionWithView(flashcardView,
            duration: 0.7,                          //Arbitrarily determined
            options: UIViewAnimationOptions.TransitionFlipFromRight,
            animations: {
                self.flashcardWordLabel.hidden = !(self.flashcardWordLabel.hidden)
                self.flashcardDefinitionLabel.hidden = !(self.flashcardDefinitionLabel.hidden)
                },
            completion: nil)
    }
    
    func panned(sender:UIPanGestureRecognizer){
        let location = sender.locationInView(self.view)
        switch sender.state {
        case .Began:
            println("Pan start")
            attachmentBehavior = UIAttachmentBehavior(item: flashcardView, attachedToAnchor: originalCenter)
            animator.addBehavior(attachmentBehavior)
            attachmentBehavior!.anchorPoint.x = location.x  //Don't want flashcard moving vertically
            
        case .Ended:
            println("Pan end")
            
            animator.removeAllBehaviors()       //Doesn't quite work if behaviors stick around (except item behavior)
            itemBehavior = UIDynamicItemBehavior(items: [flashcardView])
            itemBehavior.allowsRotation = false
            itemBehavior.friction = 0.7
            
            let velocity = sender.velocityInView(view)
            let magnitude = abs(velocity.x)     //Covers both directions
            
            if magnitude > ThrowingThreshold {
                println("Push initiated")
                pushBehavior = UIPushBehavior(items: [flashcardView], mode: .Instantaneous)
                pushBehavior.pushDirection = CGVector(dx: velocity.x, dy: 0)
                pushBehavior.magnitude = magnitude / ThrowingVelocityPadding
                animator.addBehavior(pushBehavior)

                let timeOffset = Int64(0.4 * Double(NSEC_PER_SEC))
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeOffset), dispatch_get_main_queue()) {
                    if (!self.inView(self.flashcardView.frame)) {
                        let flashcardX = self.flashcardView.frame.origin.x
                        
                        if flashcardX > 0 {                 //Offscreen to the right, to previous card
                            if self.currentFlashcardNumber > 0 {
                                self.currentFlashcardNumber -= 1
                                self.showCard()
                                self.flashcardView.frame.origin.x = -flashcardX
                            }
                        }
                        if flashcardX < 0 {                 //Offscreen to the left, to next card
                            if self.currentFlashcardNumber < self.currentCategory!.wordCount - 1 {
                                self.currentFlashcardNumber += 1
                                self.showCard()
                                self.flashcardView.frame.origin.x = -flashcardX
                            }
                        }
                    }
                    self.resetFlashcardPosition()       //Needs to be inside if{} so push has time to animate offscreen
                }
            } else { self.resetFlashcardPosition() }    //If no push, just reset right away
        default:
            attachmentBehavior!.anchorPoint.x = sender.locationInView(view).x
        }
    }
    
    func resetFlashcardPosition() {
        println("Resetting")
        animator.removeAllBehaviors()       //Things don't like to work unless all behaviors are gone besides item behavior
        itemBehavior = UIDynamicItemBehavior(items: [flashcardView])
        itemBehavior.allowsRotation = false
        itemBehavior.friction = 0.7
        
        UIView.animateWithDuration(0.45,
            animations: {
            self.flashcardView.bounds = self.originalBounds
            self.flashcardView.center = self.view.center
            }
        )
        println("Flashcard bounds: \(flashcardView.bounds)")
        println("Flashcard center: \(flashcardView.center)")
        
    }
    
    @IBAction func deleteCurrentCard(sender: UIBarButtonItem) {
        if (currentFlashcard != nil){
            currentFlashcard!.removeFromCategory(currentCategory!.title)
            currentCategory!.getWords()
            showCard()
        }
    }
}
