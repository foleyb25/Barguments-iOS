import UIKit

class LandscapeNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = .black
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .all
    }
    
    override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? true
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.preferredInterfaceOrientationForPresentation ?? .landscapeLeft
    }
}
