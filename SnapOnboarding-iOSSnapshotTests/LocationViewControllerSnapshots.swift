import SnapFBSnapshotBase
@testable import SnapOnboarding_iOS

class LocationViewControllerSnapshots: SnapFBSnapshotBase {
    
    var vc: SnapOnboardingViewController!
    
    override func setUp() {
        vc = getSnapOnboardingViewController()
        
        let delegate = mockSnapOnboardingDelegate()
        let viewModel = mockSnapOnboardingViewModelNorwegian()
        let configuration = SnapOnboardingConfiguration(delegate: delegate, viewModel: viewModel)
        vc.applyConfiguration(configuration)
        
        sutBackingViewController = vc
        sut = vc.view
        
        // Setup the loaded view
        currentPage = 1
        
        super.setUp()
        recordMode = recordAll || false
    }
    
    override func tearDown() {
        vc = nil
        
        super.tearDown()
    }
    
}

extension LocationViewController {
    
    override func viewWillLayoutSubviews() {
        setupForScreenSize(parentViewController!.view.frame)
    }
    
}
