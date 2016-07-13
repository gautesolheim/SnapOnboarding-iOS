import SnapFBSnapshotBase
@testable import SnapOnboarding_iOS

class IntroViewControllerSnapshots: SnapFBSnapshotBase {
    
    override func setUp() {
        let vc = getSnapOnboardingViewController()
        
        let delegate = mockSnapOnboardingDelegate()
        let configuration = SnapOnboardingConfiguration(delegate: delegate, viewModel: viewModel)
        vc.applyConfiguration(configuration)
        
        sutBackingViewController = vc
        sut = vc.view
        
        // Setup the loaded view
        currentPage = 0
        
        super.setUp()
        recordMode = recordAll || false
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
}

extension IntroViewController {
    
    override func viewWillLayoutSubviews() {
        setupForScreenSize(parentViewController!.view.frame.size)
    }
    
}

extension TagsCollectionViewController {
    
    override func viewWillLayoutSubviews() {
        setupForScreenSize(parentViewController!.parentViewController!.view.frame.size)
        configuration = createConfiguration()
        buttonConfiguration = createButtonConfiguration()
    }
    
}
