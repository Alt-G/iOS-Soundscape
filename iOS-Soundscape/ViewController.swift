// View Controller For iOS-Soundscape
// Created By Alt-G

import UIKit
import AVFoundation

class ViewController: UIViewController {    
    
    // Init Multi Playback OpenAL Object
    var player = oalPlayback_MultiTest();
    
    // Init Listener Image
    let listener_image = UIImage(named: "Listener.png") as UIImage?
    
    // Init Source Images
    let upper_left_image = UIImage(named: "Canteen.png") as UIImage?
    let upper_right_image = UIImage(named: "Axe.png") as UIImage?
    let lower_left_image = UIImage(named: "Fire.png") as UIImage?
    let lower_right_image = UIImage(named: "Bear.png") as UIImage?

    // Init Gradient Variables
    var gradient : CAGradientLayer?
    var toColors : AnyObject?
    var fromColors : AnyObject?
    
    // Init Background Sound
    var background_sound_player: AVAudioPlayer!
    var background_file_URL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Background", ofType: "mp3")!)
    let background_volume: Float = 0.25
    
    // Attempt to Set Width Height As Variable, creates typecast error.
    // let view_width = UIScreen.mainScreen().bounds.size.width
    // let view_height = UIScreen.mainScreen().bounds.size.height
    
//------------------------------------------------------------------------------
// Load View:
//  - Creates A Self Reference to a UIView
//  - Creates Gesture Variables, and attaches to Gesture Functions
//  - Creates 4 Source UI Objects, and A Listener UI Object
    
    
    override func loadView() {
        
        // Set Default View
        self.view = UIView()
        
        // Create Gestures
        let panner = UIPanGestureRecognizer(target: self, action: "handlePan:")
        let sourcePanner0 = UIPanGestureRecognizer(target: self, action: "handleSourcePan0:")
        let sourcePanner1 = UIPanGestureRecognizer(target: self, action: "handleSourcePan1:")
        let sourcePanner2 = UIPanGestureRecognizer(target: self, action: "handleSourcePan2:")
        let sourcePanner3 = UIPanGestureRecognizer(target: self, action: "handleSourcePan3:")
        
        // Upper Left
        let upper_left_source_icon = UIImageView(image: upper_left_image)
        upper_left_source_icon.frame = CGRect(x: 0, y:0, width: 50, height: 50)
        upper_left_source_icon.center = CGPointMake(
            2*(UIScreen.mainScreen().bounds.size.width / 8),
            (UIScreen.mainScreen().bounds.size.height / 8)
        )
        upper_left_source_icon.userInteractionEnabled = true
        upper_left_source_icon.addGestureRecognizer(sourcePanner0)
        view.addSubview(upper_left_source_icon)
        player.sourcePos0 = upper_left_source_icon.center
        
        // Upper Right
        let upper_right_source_icon = UIImageView(image: upper_right_image)
        upper_right_source_icon.frame = CGRect(x: 250, y:250, width: 50, height: 50)
        upper_right_source_icon.center = CGPointMake(
            6*(UIScreen.mainScreen().bounds.size.width / 8),
            (UIScreen.mainScreen().bounds.size.height / 8)
        )
        upper_right_source_icon.userInteractionEnabled = true
        upper_right_source_icon.addGestureRecognizer(sourcePanner1)
        view.addSubview(upper_right_source_icon)
        player.sourcePos1 = upper_right_source_icon.center
        
        // Lower Left
        let lower_left_source_icon = UIImageView(image: lower_left_image)
        lower_left_source_icon.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        lower_left_source_icon.center = CGPointMake(
            2*(UIScreen.mainScreen().bounds.size.width / 8),
            7*(UIScreen.mainScreen().bounds.size.height / 8)
        )
        lower_left_source_icon.userInteractionEnabled = true
        lower_left_source_icon.addGestureRecognizer(sourcePanner2)
        view.addSubview(lower_left_source_icon)
        player.sourcePos2 = lower_left_source_icon.center
        
        // Lower Right
        let lower_right_source_icon = UIImageView(image: lower_right_image)
        lower_right_source_icon.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        lower_right_source_icon.center = CGPointMake(
            6*(UIScreen.mainScreen().bounds.size.width / 8),
            7*(UIScreen.mainScreen().bounds.size.height / 8)
        )
        lower_right_source_icon.userInteractionEnabled = true
        lower_right_source_icon.addGestureRecognizer(sourcePanner3)
        view.addSubview(lower_right_source_icon)
        player.sourcePos3 = lower_right_source_icon.center
        
        // Add Moveable Icon For Listener Attachment
        let listener_icon = UIImageView(image: listener_image)
        listener_icon.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        listener_icon.center = CGPointMake(
            UIScreen.mainScreen().bounds.size.width / 2,
            UIScreen.mainScreen().bounds.size.height / 2
        )
        listener_icon.userInteractionEnabled = true
        listener_icon.addGestureRecognizer(panner)
        view.addSubview(listener_icon)
        player.listenerPos = listener_icon.center
    
        // Set Non-OpenAL Sounds
        do {
            let sound = try AVAudioPlayer(contentsOfURL: background_file_URL)
            background_sound_player = sound
            sound.volume = background_volume
            sound.numberOfLoops = -1
            sound.play()
        } catch {
            // couldn't load file
        }
    }
    
//------------------------------------------------------------------------------
    
    // Post Load View Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        player.startSound()
    }
    // Load Gradient Color Animation
    override func viewDidAppear(animated: Bool) {
        
        self.gradient = CAGradientLayer()
        self.gradient?.frame = self.view.bounds
        self.gradient?.colors = [UIColor.lightGrayColor().CGColor, UIColor.whiteColor().CGColor]
        self.view.layer.insertSublayer(self.gradient!, atIndex: 0)
        
        self.toColors = [UIColor.greenColor().CGColor, UIColor.cyanColor().CGColor]
        animateLayer()
    }
    
    
    // Listener Pan Gesture, attaches OpenAL player to Icon
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
    
    // Source[0] Pan Gesture, attaches OpenAL Source To Icon
    func handleSourcePan0(sender: UIPanGestureRecognizer) {
        //self.view.bringSubviewToFront(sender.view)
        let translation = sender.translationInView(self.view)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x,
            y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPointZero, inView: self.view)
        player.sourcePos0 = sender.view!.center
        print(sender.view!.center)
        print(player.sourcePos0)
    }
    
    // Source[1] Pan Gesture, attaches OpenAL Source To Icon
    func handleSourcePan1(sender: UIPanGestureRecognizer) {
        //self.view.bringSubviewToFront(sender.view)
        let translation = sender.translationInView(self.view)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x,
            y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPointZero, inView: self.view)
        player.sourcePos1 = sender.view!.center
        print(sender.view!.center)
        print(player.sourcePos1)
    }
    
    // Source[2] Pan Gesture, attaches OpenAL Source To Icon
    func handleSourcePan2(sender: UIPanGestureRecognizer) {
        //self.view.bringSubviewToFront(sender.view)
        let translation = sender.translationInView(self.view)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x,
            y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPointZero, inView: self.view)
        player.sourcePos2 = sender.view!.center
        print(sender.view!.center)
        print(player.sourcePos2)
    }
    
    // Source[3] Pan Gesture, attaches OpenAL Source To Icon
    func handleSourcePan3(sender: UIPanGestureRecognizer) {
        //self.view.bringSubviewToFront(sender.view)
        let translation = sender.translationInView(self.view)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x,
            y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPointZero, inView: self.view)
        player.sourcePos3 = sender.view!.center
        print(sender.view!.center)
        print(player.sourcePos3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Color Gradient Cycle Functio
    func animateLayer(){
        
        self.fromColors = self.gradient?.colors
        self.gradient!.colors = self.toColors! as? [AnyObject] // You missed this line
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.delegate = self
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 20.00
        animation.removedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.delegate = self
        
        self.gradient?.addAnimation(animation, forKey:"animateGradient")
    }
    
    // This creates the loop for the gradient color change
    override func animationDidStop(anim: (CAAnimation!), finished flag: Bool) {
        
        self.toColors = self.fromColors;
        self.fromColors = self.gradient?.colors
        
        animateLayer()
    }
    
}

