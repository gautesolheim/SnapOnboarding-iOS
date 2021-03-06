import XCTest
@testable import SnapOnboarding_iOS

class SnapOnboardingDelegateTests: XCTestCase {
    
    var vc: SnapOnboardingViewController!

    fileprivate var isOnboardingWillAppearCalled = false
    fileprivate var isTermsAndConditionsTapped = false
    fileprivate var isPrivacyPolicyTapped = false
    fileprivate var isEnableLocationServicesTapped = false
    fileprivate var isLocationServicesInstructionsTapped = false
    fileprivate var isFacebookSignupTapped = false
    fileprivate var isInstagramSignupTapped = false
    fileprivate var isSkipLoginTapped = false
    fileprivate var isContinueAsLoggedInUserTapped = false
    fileprivate var isLogoutFromCurrentAccountTapped = false
    
    override func setUp() {
        super.setUp()
        
        let delegate = self as SnapOnboardingDelegate
        let viewModel = mockSnapOnboardingViewModelNorwegian()
        vc = getSnapOnboardingViewController()
        
        vc.applyConfiguration(SnapOnboardingConfiguration(delegate: delegate, viewModel: viewModel))
        _ = vc.view // Force loading of the view
    }
    
    override func tearDown() {
        super.tearDown()

        isOnboardingWillAppearCalled = false
        isTermsAndConditionsTapped = false
        isPrivacyPolicyTapped = false
        isEnableLocationServicesTapped = false
        isLocationServicesInstructionsTapped = false
        isFacebookSignupTapped = false
        isInstagramSignupTapped = false
        isSkipLoginTapped = false
        isContinueAsLoggedInUserTapped = false
        isLogoutFromCurrentAccountTapped = false
        
        vc.childViewControllers.forEach { child in
            (child as? HasSparklingStars)?.sparklingStars?.forEach { $0.layer.removeAllAnimations() }
        }
    }

    func testIsOnboardingWillAppearCalled() {
        XCTAssertFalse(isOnboardingWillAppearCalled)

        vc.viewWillAppear(false)
        XCTAssertTrue(isOnboardingWillAppearCalled)
    }
    
    func testTermsAndConditionsTapped() {
        vc.attributedLabel(vc.termsAndConditionsLabel, didSelectLinkWith: URL(string: "terms"))
        XCTAssertTrue(isTermsAndConditionsTapped)
    }
    
    func testPrivacyPolicyTapped() {
        vc.attributedLabel(vc.termsAndConditionsLabel, didSelectLinkWith: URL(string: "privacy"))
        XCTAssertTrue(isPrivacyPolicyTapped)
    }
    
    func testEnableLocationServicesButtonTapped() {
        let locationVC: LocationViewController = getChildVCOfType()!
        
        locationVC.enableLocationServicesButtonTapped(locationVC.enableLocationServicesButton!)
        XCTAssertTrue(isEnableLocationServicesTapped)
    }
    
    func testLocationServicesInstructionsTapped() {
        let locationVC: LocationViewController = getChildVCOfType()!
        
        locationVC.willAskLaterLabelWithLocationServicesInstructionsTapped()
        XCTAssertTrue(isLocationServicesInstructionsTapped)
    }
    
    func testFacebookSignupTapped() {
        let loginVC: LoginViewController = getChildVCOfType()!
        
        loginVC.continueWithFacebookButtonTapped(loginVC.continueWithFacebookButton!)
        XCTAssertTrue(isFacebookSignupTapped)
    }
    
    func testInstagramSignupTapped() {
        let loginVC: LoginViewController = getChildVCOfType()!
        
        loginVC.continueWithInstagramButtonTapped(loginVC.continueWithInstagramButton!)
        XCTAssertTrue(isInstagramSignupTapped)
    }
    
    func testSkipLoginTapped() {
        let loginVC: LoginViewController = getChildVCOfType()!
        
        loginVC.skipLoginButtonTapped(loginVC.skipLoginButton!)
        XCTAssertTrue(isSkipLoginTapped)
    }

    func testContinueAsLoggedInUserTapped() {
        let loginVC: LoginViewController = getChildVCOfType()!

        loginVC.continueAsLoggedInUserButtonTapped(loginVC.continueAsLoggedInUserButton!)
        XCTAssertTrue(isContinueAsLoggedInUserTapped)
    }

    func testLogoutFromCurrentAccountTapped() {
        let loginVC: LoginViewController = getChildVCOfType()!

        loginVC.changeAccountButtonTapped(loginVC.changeAccountButton!)
        XCTAssertTrue(isLogoutFromCurrentAccountTapped)
    }
    
    func testStarsBeginSparklingOnViewWillAppear() {
        applyExpressionOnAllSparklingStars { XCTAssertEqual($0.layer.animationKeys()?.count, nil) }
        
        vc.viewWillAppear(false)
        applyExpressionOnAllSparklingStars { XCTAssertEqual($0.layer.animationKeys()?.count, 1) }
    }
    
    func testStarsStopSparklingOnViewDidDisappear() {
        vc.viewWillAppear(false)
        applyExpressionOnAllSparklingStars { XCTAssertEqual($0.layer.animationKeys()?.count, 1) }
        
        vc.viewDidDisappear(false)
        applyExpressionOnAllSparklingStars { XCTAssertEqual($0.layer.animationKeys()?.count, nil) }
    }
    
    // MARK: Helpers
    
    func getChildVCOfType<T>() -> T? {
        for child in vc.childViewControllers {
            if let child = child as? T {
                return child
            }
        }
        return nil
    }
    
    func applyExpressionOnAllSparklingStars(_ expression: @escaping (UIImageView) -> Void) {
        vc.childViewControllers.forEach { child in
            (child as! HasSparklingStars).sparklingStars!.forEach { star in
                expression(star)
            }
        }
    }
    
}

// MARK: - SnapOnboardingDelegate

extension SnapOnboardingDelegateTests: SnapOnboardingDelegate {

    func onboardingWillAppear() {
        isOnboardingWillAppearCalled = true
    }
    
    func termsAndConditionsTapped() {
        isTermsAndConditionsTapped = true
    }
    
    func privacyPolicyTapped() {
        isPrivacyPolicyTapped = true
    }
    
    func enableLocationServicesTapped() {
        isEnableLocationServicesTapped = true
    }
    
    func locationServicesInstructionsTapped() {
        isLocationServicesInstructionsTapped = true
    }
    
    func facebookSignupTapped() {
        isFacebookSignupTapped = true
    }
    
    func instagramSignupTapped() {
        isInstagramSignupTapped = true
    }
    
    func skipLoginTapped() {
        isSkipLoginTapped = true
    }

    func continueAsLoggedInUserTapped() {
        isContinueAsLoggedInUserTapped = true
    }

    func logoutFromCurrentAccountTapped() {
        isLogoutFromCurrentAccountTapped = true
    }
    
}
