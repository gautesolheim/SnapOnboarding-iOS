//
//  SnapOnboarding_iOSTests.swift
//  SnapOnboarding-iOSTests
//
//  Created by Gaute Solheim on 13.06.2016.
//  Copyright © 2016 Gaute Solheim. All rights reserved.
//

import XCTest
@testable import SnapOnboarding_iOS

class SnapOnboardingDelegateTests: XCTestCase {
    
    var delegate: SnapOnboardingDelegate!
    var viewController: SnapOnboardingViewController!
    
    private var isTermsAndConditionsTapped = false
    private var isPrivacyPolicyTapped = false
    private var isEnableLocationServicesTapped = false
    private var isFacebookSignupTapped = false
    private var isInstagramSignupTapped = false
    private var isWillDismissExecuted = false
    private var isDidDismissExecuted = false
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let delegate = self as SnapOnboardingDelegate
        let viewModel = mockSnapOnboardingViewModelNorwegian()
        let viewController = getSnapOnboardingViewController()
        
        viewController.applyConfiguration(SnapOnboardingConfiguration(delegate: delegate, viewModel: viewModel))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTermsAndConditionsTapped() {
//        viewController.attributedLabel(viewController.termsand, didSelectLinkWithURL: <#T##NSURL!#>)
    }
    
}

// MARK: - SnapOnboardingDelegate

extension SnapOnboardingDelegateTests: SnapOnboardingDelegate {
    
    func termsAndConditionsTapped() {
        isTermsAndConditionsTapped = true
    }
    
    func privacyPolicyTapped() {}
    
    func enableLocationServicesTapped() {}
    
    func facebookSignupTapped() {}
    func instagramSignupTapped() {}
    
    func willDismiss() {}
    func didDismiss() {}
    
}
