//
//  ViewController.swift
//  iOS-Soundscape
//
//  Created by Mindspyk on 2/23/16.
//  Copyright © 2016 Alt-G. All rights reserved.
//
import UIKit
import QuartzCore
class ViewController: UIViewController {
    var myPlay = oalPlayback();
    //@IBOutlet weak var playback: oalPlayback!
    //@IBOutlet var musicSwitch: UISwitch!
    @IBOutlet weak var listener: UIImageView!
    @IBAction func toggleMusic(sender: UISwitch) {
        NSLog("toggling music %@", sender.on ? "on" : "off")
        if myPlay.bgPlayer != nil {
            if sender.on {
                myPlay.bgPlayer?.play()
            } else {
                myPlay.bgPlayer?.stop()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPlay.startSound()
        myPlay.changeTest()
        // Do any additional setup after loading the view, typically from a nib.
        //self.initializeContent();
        // SET UP ANCHOR POINTS FOR OBJECTS
        // CURRENTLY DEFAULT TO TOP LEFT OF VIEW
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func initializeContent() {
//        // Change view origin to have change origin to (0, 0)
//        let trans = CATransform3DMakeTranslation(view.frame.size.width / 2.0, view.frame.size.height / 2.0, 0.0)
//        view.layer.sublayerTransform = trans
//        listener.frame = CGRectMake(100, 80, listener.frame.size.width, listener.frame.size.height);
//        
//    }
//    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
//        // retrieves the amount the user has moved their finger
//        let translation = recognizer.translationInView(self.view)
//        // If view is being touched within its bounds
//        if let view = recognizer.view {
//            // move the center of the "view" the same amount as the finger has been dragged
//            view.center = CGPoint(x: view.center.x + translation.x,
//                y: view.center.y + translation.y)
//        }
//        print("x: \(recognizer.view!.center.x) | y: \(recognizer.view!.center.y)\n");
//        recognizer.setTranslation(CGPointZero, inView: self.view)
//    }
}

