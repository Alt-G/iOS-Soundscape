import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var player = oalPlayback_MultiTest();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panner = UIPanGestureRecognizer(target: self, action: "handlePan:")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onCustomTap:")
        
        let jungle_birds_view = UIImageView(image: UIImage(named: "jungle_birds.png"))
        jungle_birds_view.frame = CGRect(x: 300, y:600, width: 50, height: 50)
        view.addSubview(jungle_birds_view)
        
        let rain_thunder_view = UIImageView(image: UIImage(named: "rain_thunder.png"))
        rain_thunder_view.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        view.addSubview(rain_thunder_view)
        
        let imgView = UIImageView(image: UIImage(named: "Headphone.png"))
        imgView.frame = CGRect(x: 150, y: 300, width: 50, height: 50)
        imgView.backgroundColor = UIColor.redColor()
        imgView.userInteractionEnabled = true
        imgView.addGestureRecognizer(panner)
        imgView.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(imgView)
        player.startSound()
        
    }
    
    func onCustomTap(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(view)
        print(point)
        
        // User tapped at the point above. Do something with that if you want.
    }
    
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
    
    //    func handlePan(recognizer: UIPanGestureRecognizer) {
    //        let translation = recognizer.translationInView(self.view)
    //        if let view = recognizer.view {
    //            view.center = CGPoint(x:view.center.x + translation.x,
    //                y:view.center.y + translation.y)
    //        }
    //        recognizer.setTranslation(CGPointZero, inView: self.view)
    //    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

