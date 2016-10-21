import SnapFBSnapshotBase
@testable import SnapOnboarding_iOS

class LoginViewControllerWelcomeBackSnapshots: SnapFBSnapshotBase {

    var vc: SnapOnboardingViewController!

    override func setUp() {
        vc = getSnapOnboardingViewController()

        let delegate = mockSnapOnboardingDelegate()
        let configuration = SnapOnboardingConfiguration(delegate: delegate, viewModel: viewModel)
        vc.applyConfiguration(configuration)

        sutBackingViewController = vc
        sut = vc.view
//        vc.viewWillAppear(false)

        UIApplication.shared.keyWindow?.rootViewController = vc
        UIApplication.shared.keyWindow?.rootViewController = nil

        // Setup the loaded view
        currentPage = 3
        
        let userViewModel = mockUserViewModel()
        vc.applyFormerAuthorizationService(.facebook, userViewModel: userViewModel)

        super.setUp()
        recordMode = recordAll || false
    }

    override func tearDown() {
        vc = nil

        super.tearDown()
    }

}
