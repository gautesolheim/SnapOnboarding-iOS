//
//  ViewController.swift
//  SnapOnboarding-iOS
//
//  Created by Gaute Solheim on 13.06.2016.
//  Copyright © 2016 Gaute Solheim. All rights reserved.
//

import UIKit
import RazzleDazzle

class ViewController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        presentOnboardingViewController()
    }
    
    private func presentOnboardingViewController() {
        let storyboard = UIStoryboard(name: "SnapOnboarding", bundle: nil)
        let onboardingViewController = storyboard.instantiateViewControllerWithIdentifier("snapOnboardingViewController") as! SnapOnboardingViewController
        
        let exampleColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 88/255.0, alpha: 1.0)
        let configuration = SnapOnboardingViewControllerConfiguration(delegate: self, backgroundColor: exampleColor)
        
        onboardingViewController.applyConfiguration(configuration)
        
        presentViewController(onboardingViewController, animated: false, completion: nil)
    }

}

