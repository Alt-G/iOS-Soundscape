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
    @IBOutlet weak var playback: oalPlayback!
    @IBOutlet var musicSwitch: UISwitch!
    
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
        let trans = CATransform3DMakeTranslation(view.frame.size.width / 2.0, view.frame.size.height / 2.0, 0.0)
        view.layer.sublayerTransform = trans
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
        // retrieves the amount the user has moved their finger
        let translation = recognizer.translationInView(self.view)
        // If view is being touched within its bounds
        if let view = recognizer.view {
            // move the center of the "view" the same amount as the finger has been dragged
            view.center = CGPoint(x: view.center.x + translation.x,
            y: view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }


}

