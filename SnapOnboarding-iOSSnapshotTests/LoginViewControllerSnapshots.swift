import SnapSnapshotBase
@testable import SnapOnboarding_iOS

class LoginViewControllerSnapshots: FBSnapshotBase {
    
    var vc: SnapOnboardingViewController!
    
    override func setUp() {
        vc = getSnapOnboardingViewController()
        
        let delegate = mockSnapOnboardingDelegate()
        let viewModel = mockSnapOnboardingViewModelNorwegian()
        let configuration = SnapOnboardingConfiguration(delegate: delegate, viewModel: viewModel)
        vc.applyConfiguration(configuration)
        
        currentPage = 2
        
        sut = vc.view
        sut.setNeedsDisplay()
        sut.layoutIfNeeded()
        
        super.setUp()
        recordMode = self.recordAll || false
    }
    
    override func tearDown() {
        vc = nil
        
        super.tearDown()
    }
    
}

extension LoginViewController {
    
    override func viewWillLayoutSubviews() {
        setupForScreenSize(parentViewController!.view.frame)
    }
    
}
