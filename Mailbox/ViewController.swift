//
//  ViewController.swift
//  Mailbox
//
//  Created by Carolyn Yang - Vendor on 10/22/15.
//  Copyright © 2015 Carolyn Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var rightBlock: UIImageView!
    @IBOutlet weak var leftBlock: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    //
    var messageLocation: CGPoint!
    var mainViewLocation: CGPoint!
    var messageStartLocation: CGPoint!
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrollView.contentSize.height = 1430
        messageStartLocation = messageView.center
        //
        self.rightBlock.backgroundColor = UIColor.lightGrayColor()
        self.leftBlock.backgroundColor = UIColor.lightGrayColor()
    }
    
    
    @IBAction func dismissTap(sender: UIButton) {
        rescheduleView.alpha = 0
        listView.alpha = 0
        dismissButton.enabled = false
        self.messageView.center = self.messageStartLocation
    }
    
    @IBAction func messagePanGesture(panGestureRecognizer: UIPanGestureRecognizer) {

        // Absolute (x,y) coordinates in parent view
        //var point = panGestureRecognizer.locationInView(view)
        
        // Relative change in (x,y) coordinates from where gesture began.
        let translation = panGestureRecognizer.translationInView(view)
        //var velocity = panGestureRecognizer.velocityInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            messageLocation = messageView.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            messageView.center = CGPoint(x: messageLocation.x+translation.x, y:messageLocation.y)
            //
            let positionDiff = messageStartLocation.x-messageView.center.x
            print(positionDiff)
            if(positionDiff<60 && positionDiff>0){
                rightBlock.image = UIImage(named: "later_icon")
                UIView.animateWithDuration(0.2, animations: {
                    self.rightBlock.backgroundColor = UIColor.lightGrayColor()
                })
            }else if(positionDiff<260 && positionDiff>60){
                rightBlock.image = UIImage(named: "later_icon")
                UIView.animateWithDuration(0.2, animations: {
                    self.rightBlock.backgroundColor = UIColor.orangeColor()
                })
            }else if(positionDiff>260){
                rightBlock.image = UIImage(named: "list_icon")
                UIView.animateWithDuration(0.2, animations: {
                    self.rightBlock.backgroundColor = UIColor.brownColor()
                })
            }else if(positionDiff<0 && positionDiff > (-60)){
             //Gray
                UIView.animateWithDuration(0.2, animations: {
                    self.leftBlock.backgroundColor = UIColor.lightGrayColor()
                })
            }else if(positionDiff < (-60) && positionDiff > (-260)){
                //Green
                UIView.animateWithDuration(0.2, animations: {
                    self.leftBlock.backgroundColor = UIColor.greenColor()
                })

            }else if(positionDiff < (-260)){
                //Red
                UIView.animateWithDuration(0.2, animations: {
                    self.leftBlock.backgroundColor = UIColor.redColor()
                })

            }
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {

 
            let positionDiff = messageStartLocation.x-messageView.center.x
            
            if(positionDiff<60 && positionDiff > -60){
                //Snap back
                UIView.animateWithDuration(0.2, animations: {
                    self.messageView.center = self.messageStartLocation
                })
            }else if(positionDiff>60 && positionDiff<260){
                // Snap to yellow
                UIView.animateWithDuration(0.2, animations: {
                    self.messageView.center.x = self.messageStartLocation.x-320
                    self.rescheduleView.alpha = 1.0
                })
                dismissButton.enabled = true
            }else if(positionDiff>260 && positionDiff<320){
                UIView.animateWithDuration(0.2, animations: {
                    self.messageView.center.x = self.messageStartLocation.x-320
                    self.listView.alpha = 1.0
                })
                dismissButton.enabled = true
            }else if (positionDiff>320 || positionDiff < (-320)){
                UIView.animateWithDuration(0.2, animations: {
                    self.messageView.center = self.messageStartLocation
                })
            }else if (positionDiff < (-60) && positionDiff > (-260)){
                UIView.animateWithDuration(0.2, animations: {
                    self.messageView.center.x = self.messageStartLocation.x+320
                },
                    completion:{
                        (value: Bool) in
                        self.messageView.alpha = 0
                        self.scrollView.contentOffset.y+=86
                })
                
            }else if(positionDiff < (-260)){
                UIView.animateWithDuration(0.2, animations: {
                    self.messageView.center.x = self.messageStartLocation.x+320
                    },
                    completion:{
                        (value: Bool) in
                        self.messageView.alpha = 0
                        self.scrollView.contentOffset.y+=86
                })
            }
        }

    }
    
    @IBAction func mainMenuPan(panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translationInView(view)
        let velocity = panGestureRecognizer.velocityInView(view)
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            mainViewLocation = mainView.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            mainView.center = CGPoint(x: mainViewLocation.x+translation.x, y:mainViewLocation.y)
        }else if panGestureRecognizer.state == UIGestureRecognizerState.Ended{
            if (velocity.x < 0){
                UIView.animateWithDuration(0.5, animations: {
                    self.mainView.center.x = 340
                })

            }else{
                UIView.animateWithDuration(0.5, animations: {
                    self.mainView.center.x = 600
                })
                
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
