import UIKit

public class SnapOnboardingViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet var pageControl: UIPageControl?
    
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
    
    // MARK: - UIPageControl
    
    private func updatePageControl() {
        guard let scrollView = scrollView else {
            return
        }
        print(scrollView.contentOffset.x)
        
        let viewWidth = view.frame.width
        
        switch scrollView.contentOffset.x {
        case 0:
            pageControl?.currentPage = 0
        case viewWidth:
            pageControl?.currentPage = 1
        case viewWidth * 2:
            pageControl?.currentPage = 2
        default: break
        }
    }
    
    // MARK: - UIViewController properties
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

// MARK: - UIScrollViewDelegate

extension SnapOnboardingViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        updatePageControl()
    }
    
}