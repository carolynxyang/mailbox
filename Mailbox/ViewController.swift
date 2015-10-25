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
        animateMessage(nil, leftIcon:nil, rightColor:nil, rightIcon:nil, x:self.messageStartLocation.x)
        
    }
    
    func animateMessage(leftColor:UIColor?, leftIcon:String?, rightColor:UIColor?, rightIcon:String?, x:CGFloat?){
        UIView.animateWithDuration(0.5, animations: {
            if(rightColor != nil){
                self.rightBlock.backgroundColor = rightColor
            }
            
            if(rightIcon != nil){
                self.rightBlock.image = UIImage(named: rightIcon!)
            }
            
            if(leftColor != nil){
                self.leftBlock.backgroundColor = leftColor
            }
            
            if(leftIcon != nil){
                self.leftBlock.image = UIImage(named: leftIcon!)
            }
            if(x != nil){
                self.messageView.center.x = x!
            }
            
        })
    }
    
    @IBAction func messagePanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = panGestureRecognizer.translationInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            messageLocation = messageView.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            messageView.center = CGPoint(x: messageLocation.x+translation.x, y:messageLocation.y)
            //
            let positionDiff = messageStartLocation.x-messageView.center.x
            print(positionDiff)
            if(positionDiff < 60 && positionDiff > -60){
                animateMessage(UIColor.lightGrayColor(), leftIcon:"archive_icon", rightColor:UIColor.lightGrayColor(), rightIcon:"later_icon", x:nil)
            }else if(positionDiff < 260 && positionDiff > 60){
                animateMessage(nil, leftIcon:nil, rightColor:UIColor.orangeColor(), rightIcon:"later_icon", x:nil)
            }else if(positionDiff > 260){
                animateMessage(nil, leftIcon:nil, rightColor:UIColor.brownColor(), rightIcon:"list_icon", x:nil)
            }else if(positionDiff < -60 && positionDiff > -260){
                //Green
                animateMessage(UIColor.greenColor(), leftIcon:"archive_icon", rightColor:nil, rightIcon:nil, x:nil)
            }else if(positionDiff < -260){
                animateMessage(UIColor.redColor(), leftIcon:"delete_icon", rightColor:nil, rightIcon:nil, x:nil)
            }
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            
            let positionDiff = messageStartLocation.x-messageView.center.x
            
            if(positionDiff < 60 && positionDiff > -60){
                //Snap back
                animateMessage(nil, leftIcon:nil, rightColor:nil, rightIcon:nil, x:self.messageStartLocation.x)
            }else if(positionDiff > 60 && positionDiff < 260){
                // Snap to yellow
                animateMessage(nil, leftIcon:nil, rightColor:nil, rightIcon:nil, x:self.messageStartLocation.x-320)
                self.rescheduleView.alpha = 1.0
                dismissButton.enabled = true
            }else if(positionDiff > 260 && positionDiff < 320){
                animateMessage(nil, leftIcon:nil, rightColor:nil, rightIcon:nil, x:self.messageStartLocation.x-320)
                self.listView.alpha = 1.0
                dismissButton.enabled = true
            }else if (positionDiff > 320 || positionDiff < -320){
                animateMessage(nil, leftIcon:nil, rightColor:nil, rightIcon:nil, x:self.messageStartLocation.x)
            }else if (positionDiff < -60){
                UIView.animateWithDuration(0.2, animations: {
                    self.messageView.center.x = self.messageStartLocation.x+320
                    },
                    completion:{
                        (value: Bool) in
                        UIView.animateWithDuration(0.2, animations: {
                            self.messageView.alpha = 0
                            self.scrollView.contentInset.top-=86
                        })
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
                    self.mainView.center.x = 620
                })
                
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
