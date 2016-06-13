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
    
    private var pageControl: UIPageControl!
    
    public func applyConfiguration(configuration: OnboardingViewControllerConfiguration) {
        self.configuration = configuration
        
        setupPages()
        //setupMargins()
        setupBackground()
        //setupLabel()
        //setupOnOffButton()
    }
    
    internal func setupPages() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = configuration.numberOfPages
        contentView.addSubview(pageControl)
        keepView(pageControl, onPages: [0, 1, 2])
    }
    
    internal func setupBackground() {
        view.backgroundColor = configuration.backgroundColor
    }
    
    // MARK: - RazzleDazzle setup
    
    public override func numberOfPages() -> Int {
        return configuration.numberOfPages
    }
    
    // MARK: - UIScrollViewDelegate
    
    public override func scrollViewDidScroll(scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        /*print("offset: \(pageOffset)")
        print("width: \(pageWidth)")*/
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControl.currentPage = Int(pageOffset)
        print(pageControl.currentPage)
    }
    
}