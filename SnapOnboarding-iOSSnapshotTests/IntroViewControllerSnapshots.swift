import SnapSnapshotBase
@testable import SnapOnboarding_iOS

class IntroViewControllerSnapshots: FBSnapshotBase {
    
    var vc: IntroViewController!
    
    override func setUp() {
        let exampleViewController = ViewController()
        
        let storyboard = UIStoryboard(name: "SnapOnboarding", bundle: NSBundle.mainBundle())
        vc = storyboard.instantiateViewControllerWithIdentifier("introViewController") as! IntroViewController
        
        let viewModel = exampleViewController.createSampleViewModelNorwegian().introViewModel
        vc.configureForViewModel(viewModel)
        
        sut = vc.view
        sut.setNeedsDisplay()
        sut.layoutIfNeeded()
        
        super.setUp()
        recordMode = self.recordAll || true
    }
    
    override func tearDown() {
        vc = nil
        
        super.tearDown()
    }
    
}

extension IntroViewController {
    
    override func viewWillLayoutSubviews() {
        setupForScreenSize(view.frame)
    }
    
}
