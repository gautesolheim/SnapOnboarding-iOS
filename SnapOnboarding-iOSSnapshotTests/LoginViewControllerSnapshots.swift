import SnapFBSnapshotBase
@testable import SnapOnboarding_iOS

class LoginViewControllerSnapshots: SnapFBSnapshotBase {
    
    var vc: SnapOnboardingViewController!
    
    override func setUp() {
        vc = getSnapOnboardingViewController()
        
        let delegate = mockSnapOnboardingDelegate()
        let viewModel = mockSnapOnboardingViewModelNorwegian()
        let configuration = SnapOnboardingConfiguration(delegate: delegate, viewModel: viewModel)
        vc.applyConfiguration(configuration)
        
        // Prevent device size adjustments before a simulated frame is set, i.e. from viewDidLoad
        vc.screenSize = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        sutBackingViewController = vc
        sut = vc.view
        
        // Setup the loaded view
        currentPage = 2
        
        super.setUp()
        recordMode = recordAll || false
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
