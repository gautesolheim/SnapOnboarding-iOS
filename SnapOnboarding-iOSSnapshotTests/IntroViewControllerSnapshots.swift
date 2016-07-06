import SnapFBSnapshotBase
@testable import SnapOnboarding_iOS

class IntroViewControllerSnapshots: FBSnapshotBase {
    
    var vc: SnapOnboardingViewController!
    
    override func setUp() {
        vc = getSnapOnboardingViewController()
        
        let delegate = mockSnapOnboardingDelegate()
        let viewModel = mockSnapOnboardingViewModelNorwegian()
        let configuration = SnapOnboardingConfiguration(delegate: delegate, viewModel: viewModel)
        vc.applyConfiguration(configuration)
        
        // Prevent device adjustments before a simulated frame is set, i.e. from viewDidLoad
        vc.screenSize = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        sut = vc.view
        sut.setNeedsDisplay()
        
        // Setup the view
        currentPage = 0
        
        super.setUp()
        recordMode = self.recordAll || false
        
//        print("drawview: \(self.usesDrawViewHierarchyInRect)")
//        self.usesDrawViewHierarchyInRect = true
    }
    
    override func tearDown() {
        vc = nil
        
        super.tearDown()
    }
    
    override func testIphone6Portrait() {
//        let traitCollectionHorizontal = UITraitCollection(horizontalSizeClass: .Compact)
//        let traitCollectionVertical = UITraitCollection(verticalSizeClass: .Compact)
//        let traitCollection = UITraitCollection(traitsFromCollections: [traitCollectionHorizontal, traitCollectionVertical])
//        vc.setOverrideTraitCollection(traitCollection, forChildViewController: vc)
        
        print("sclass:")
        print(vc.traitCollection.horizontalSizeClass.hashValue)
        print(vc.traitCollection.verticalSizeClass.hashValue)
        
        super.testIphone6Portrait()
    }
    
}

extension IntroViewController {
    
    override func viewWillLayoutSubviews() {
        setupForScreenSize(parentViewController!.view.frame)
    }
    
}
