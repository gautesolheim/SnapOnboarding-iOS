//
//  File.swift
//  SnapOnboarding-iOS
//
//  Created by Gaute Solheim on 13.06.2016.
//  Copyright © 2016 Gaute Solheim. All rights reserved.
//

import UIKit
import RazzleDazzle

public class OnboardingViewController: AnimatedPagingScrollViewController {
    
    internal var configuration: OnboardingViewControllerConfiguration!
    
    private var pageControl = UIPageControl()
    
    public func applyConfiguration(configuration: OnboardingViewControllerConfiguration) {
        self.configuration = configuration
        
        configureBackground()
        addViews()
        configureViews()
    }
    
    // MARK: - UIView configuration
    
    private func configureBackground() {
        view.backgroundColor = configuration.backgroundColor
    }
    
    private func addViews() {
        contentView.addSubview(pageControl)
    }
    
    private func configureViews() {
        configurePageControl()
    }
    
    private func configurePageControl() {
        pageControl.numberOfPages = configuration.numberOfPages
        
        let bottom = NSLayoutConstraint(item: pageControl, attribute: .Bottom, relatedBy: .Equal, toItem: scrollView, attribute: .BottomMargin, multiplier: 1, constant: 0)
        NSLayoutConstraint.activateConstraints([bottom])
        
        keepView(pageControl, onPages: [-1, 3])
    }
    
    // MARK: - RazzleDazzle properties
    
    public override func numberOfPages() -> Int {
        return configuration.numberOfPages
    }
    
    // MARK: - UIViewController properties
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

// MARK: - UIScrollViewDelegate

extension OnboardingViewController {
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControl.currentPage = Int(pageOffset)
    }
    
}