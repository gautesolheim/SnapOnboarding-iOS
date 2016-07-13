import SnapFBSnapshotBase
@testable import SnapOnboarding_iOS

class IntroViewControllerSnapshots: SnapFBSnapshotBase {
    
    var vc: SnapOnboardingViewController!
    
    override func setUp() {
        vc = getSnapOnboardingViewController()
        
        let delegate = mockSnapOnboardingDelegate()
        let viewModel = mockSnapOnboardingViewModelEnglish()
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
        vc = nil
        
        super.tearDown()
    }
    
}

extension IntroViewController {
    
    override func viewWillLayoutSubviews() {
        setupForScreenSize(parentViewController!.view.frame.size)
        
        // viewDidLoad configuration
        configureNextButton()
        configureHeadlineLabel()
    }
    
}

extension TagsCollectionViewController {
    
    override func viewWillLayoutSubviews() {
        setupForScreenSize(parentViewController!.parentViewController!.view.frame.size)
        configuration = createConfiguration()
        buttonConfiguration = createButtonConfiguration()
    }
    
}
