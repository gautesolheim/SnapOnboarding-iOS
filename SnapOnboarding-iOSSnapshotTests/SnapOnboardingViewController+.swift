import UIKit
@testable import SnapOnboarding_iOS

var currentPage = 0

extension SnapOnboardingViewController {
    
    override public func viewWillLayoutSubviews() {
        configureTermsAndConditionsLabel()
        setupForScreenSize(view.frame.size)
    }
    
    override public func viewDidLayoutSubviews() {
        // Will reset on layoutSubviews, and must therefore be set afterwards
        scrollView?.contentOffset.x = view.frame.width * CGFloat(currentPage)
    }
    
    // Prevent adjustment to screen size before a simulated frame is set (i.e. from viewDidLoad)
    override class var screenSize: CGSize {
        return CGSize()
    }
    
}
