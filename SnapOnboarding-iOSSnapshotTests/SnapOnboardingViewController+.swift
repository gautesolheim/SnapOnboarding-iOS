import UIKit
@testable import SnapOnboarding_iOS

var currentPage = 0

extension SnapOnboardingViewController {
    
    override public func viewWillLayoutSubviews() {
        configureTermsAndConditionsLabel()
        setupForScreenSize(view.frame)
    }
    
    override public func viewDidLayoutSubviews() {
        // Will reset on layoutSubviews, and must therefore be set after
        scrollView?.contentOffset.x = view.frame.width * CGFloat(currentPage)
    }
    
}
