// View Controller For iOS-Soundscape
// Created By Alt-G

import UIKit

class ViewController: UIViewController {
    
    // Init Multi Playback OpenAL Object
    var player = oalPlayback_MultiTest();
    let listener_image = UIImage(named: "Headphone.png") as UIImage?
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
        
        // Listener Button
        let listener_button = UIButton(type: UIButtonType.Custom) as UIButton
        listener_button.frame = CGRect(x:0,y:0, width: 50, height: 50)
        listener_button.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height/2)
        listener_button.setImage(listener_image, forState: .Normal)
        listener_button.addGestureRecognizer(panner)
        view.addSubview(listener_button)
        player.listenerPos = listener_button.center
        
        // Add Moveable Icon For Listener Attachment
        //        let imgView = UIImageView(image: UIImage(named: "Headphone.png"))
        //        imgView.frame = CGRect(x: UIScreen.mainScreen().bounds.size.width/2, y: UIScreen.mainScreen().bounds.size.height/2, width: 50, height: 50)
        //        imgView.backgroundColor = UIColor.redColor()
        //        imgView.userInteractionEnabled = true
        //        imgView.addGestureRecognizer(panner)
        //        imgView.addGestureRecognizer(tapGestureRecognizer)
        //        view.addSubview(imgView)
        //        player.listenerPos = imgView.center
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
