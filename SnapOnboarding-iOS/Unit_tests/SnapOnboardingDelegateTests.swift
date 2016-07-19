import XCTest
@testable import SnapOnboarding_iOS

class SnapOnboardingDelegateTests: XCTestCase {
    
    var vc: SnapOnboardingViewController!
    
    private var isTermsAndConditionsTapped = false
    private var isPrivacyPolicyTapped = false
    private var isEnableLocationServicesTapped = false
    private var isLocationServicesInstructionsTapped = false
    private var isFacebookSignupTapped = false
    private var isInstagramSignupTapped = false
    private var isWillDismissCalled = false
    private var isDidDismissCalled = false
    
    private var didDismissCalledExpectation: XCTestExpectation!
    
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
        
        isTermsAndConditionsTapped = false
        isPrivacyPolicyTapped = false
        isEnableLocationServicesTapped = false
        isLocationServicesInstructionsTapped = false
        isFacebookSignupTapped = false
        isInstagramSignupTapped = false
        isWillDismissCalled = false
        isDidDismissCalled = false
        didDismissCalledExpectation = nil
    }
    
    func testTermsAndConditionsTapped() {
        vc.attributedLabel(vc.termsAndConditionsLabel, didSelectLinkWithURL: NSURL(string: "terms"))
        XCTAssertTrue(isTermsAndConditionsTapped)
    }
    
    func testPrivacyPolicyTapped() {
        vc.attributedLabel(vc.termsAndConditionsLabel, didSelectLinkWithURL: NSURL(string: "privacy"))
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
    
    func testWillAndDidDismissCalled() {
        didDismissCalledExpectation = expectationWithDescription("SnapOnboardingDelegate.didDismiss called")
        
        // For dismissal of vc to work, it must be in the view hierarchy
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(vc, animated: false, completion: nil)
        
        let loginVC: LoginViewController = getChildVCOfType()!
        
        loginVC.skipLoginButtonTapped(loginVC.skipLoginButton!)
        XCTAssertTrue(isWillDismissCalled)
        XCTAssertFalse(isDidDismissCalled) // Should not be true yet, dismissal is with delay
        
        waitForExpectationsWithTimeout(2, handler: { error in
            XCTAssertNil(error)
        })
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
    
}

// MARK: - SnapOnboardingDelegate

extension SnapOnboardingDelegateTests: SnapOnboardingDelegate {
    
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
    
    func willDismiss() {
        isWillDismissCalled = true
    }
    
    func didDismiss() {
        isDidDismissCalled = true
        didDismissCalledExpectation.fulfill()
    }
    
}
