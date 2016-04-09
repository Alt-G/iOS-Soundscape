// View Controller For iOS-Soundscape
// Created By Alt-G

import UIKit

class ViewController: UIViewController {
    
    // Init Multi Playback OpenAL Object
    var player = oalPlayback_MultiTest();
    let listener_image = UIImage(named: "Listener_Icon.png") as UIImage?
    let upper_left_image = UIImage(named: "rain_thunder.png") as UIImage?
    let lower_right_image = UIImage(named: "jungle_birds.png") as UIImage?
    // let view_width = UIScreen.mainScreen().bounds.size.width
    // let view_height = UIScreen.mainScreen().bounds.size.height
    
    override func loadView() {
        
        // Set Default View
        self.view = UIView()
        
        // Create Gestures
        let panner = UIPanGestureRecognizer(target: self, action: "handlePan:")
        let tapper = UITapGestureRecognizer(target: self, action: "onCustomTap:")
        
        // Add Icons
        let upper_left_source_icon = UIImageView(image: upper_left_image)
        upper_left_source_icon.frame = CGRect(x: 0, y:0, width: 50, height: 50)
        upper_left_source_icon.center = CGPointMake(
            UIScreen.mainScreen().bounds.size.width / 4,
            UIScreen.mainScreen().bounds.size.height / 4
        )
        upper_left_source_icon.addGestureRecognizer(tapper)
        view.addSubview(upper_left_source_icon)
        player.sourcePos = upper_left_source_icon.center
        
        let lower_right_source_icon = UIImageView(image: lower_right_image)
        lower_right_source_icon.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        lower_right_source_icon.center = CGPointMake(
            3*(UIScreen.mainScreen().bounds.size.width / 4),
            3*(UIScreen.mainScreen().bounds.size.height / 4)
        )
        lower_right_source_icon.addGestureRecognizer(tapper)
        view.addSubview(lower_right_source_icon)
        player.sourcePos2 = lower_right_source_icon.center
        
        // Add Moveable Icon For Listener Attachment
        let listener_icon = UIImageView(image: listener_image)
        listener_icon.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        listener_icon.center = CGPointMake(
            UIScreen.mainScreen().bounds.size.width / 2,
            UIScreen.mainScreen().bounds.size.height / 2
        )
        listener_icon.userInteractionEnabled = true
        listener_icon.addGestureRecognizer(panner)
        listener_icon.addGestureRecognizer(tapper)
        view.addSubview(listener_icon)
        player.listenerPos = listener_icon.center
    }
    
    // Load View
    override func viewDidLoad() {
        super.viewDidLoad()
        player.startSound()
        
    }
    
    // Tap Gesture For Placement Testing
    func onCustomTap(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(view)
        print(point)
    }
    
    // Pan Gesture, attaches OpenAL player to Icon
    func handlePan(sender: UIPanGestureRecognizer) {
        //self.view.bringSubviewToFront(sender.view)
        let translation = sender.translationInView(self.view)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x,
            y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPointZero, inView: self.view)
        player.listenerPos = sender.view!.center
        print(sender.view!.center)
        print(player.listenerPos)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
