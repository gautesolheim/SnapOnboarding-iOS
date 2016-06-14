import UIKit

public class SnapOnboardingViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView?
    
    @IBOutlet var pageControl: UIPageControl!
    
    
    private var configuration: SnapOnboardingViewControllerConfiguration?
    
    public func applyConfiguration(configuration: SnapOnboardingViewControllerConfiguration) {
        self.configuration = configuration
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(configuration != nil)
        
        configureBackground()
        configureScrollView()
        configurePageControl()
    }
    
    // MARK: - UIView configuration
    
    private func configureBackground() {
        view.backgroundColor = configuration?.backgroundColor
    }
    
    private func configureScrollView() {
        
    }
    
    private func configurePageControl() {
        
    }
    
    // MARK: - UIViewController properties
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

// MARK: - UIScrollViewDelegate

extension SnapOnboardingViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        print("content-offset: \(scrollView.contentOffset)")
        print("content-size: \(scrollView.contentSize)")
    }
    
}