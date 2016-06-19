//
//  ViewController.swift
//  SnapOnboarding-iOS
//
//  Created by Gaute Solheim on 13.06.2016.
//  Copyright © 2016 Gaute Solheim. All rights reserved.
//

import UIKit
import SnapFonts_iOS

class ViewController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        presentOnboardingViewController()
    }
    
    private func presentOnboardingViewController() {
        let storyboard = UIStoryboard(name: "SnapOnboarding", bundle: nil)
        let onboardingViewController = storyboard.instantiateViewControllerWithIdentifier("snapOnboardingViewController") as! SnapOnboardingViewController
        
        let exampleColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 88/255.0, alpha: 1.0)
        let configuration = SnapOnboardingConfiguration(delegate: self, backgroundColor: exampleColor)
        
        onboardingViewController.applyConfiguration(configuration)
        
        presentViewController(onboardingViewController, animated: false, completion: nil)
    }

}

extension ViewController: SnapOnboardingDelegate {
    
    func termsAndConditionsTapped() {
        print("terms-and-conditions-tapped")
    }
    
    func privacyPolicyTapped() {
        print("privacy-policy-tapped")
    }
    
    
    func enableLocationServicesTapped() {
        print("enable-location-services-tapped")
    }
    
    
    func facebookSignupTapped() {
        print("facebook-signup-tapped")
    }
    
    func instagramSignupTapped() {
        print("instagram-signup-tapped")
    }
    
    
    func willDismiss() {
        print("will-dismiss")
    }
    
    func didDismiss() {
        print("did-dismiss")
    }
    
}