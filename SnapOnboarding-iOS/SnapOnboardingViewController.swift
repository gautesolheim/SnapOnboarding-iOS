import UIKit
import TTTAttributedLabel
import SnapFonts_iOS

public class SnapOnboardingViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet var pageControl: UIPageControl?
    @IBOutlet var termsAndConditionsLabel: TTTAttributedLabel?
    
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
        configureTermsAndConditionsLabel()
    }
    
    // MARK: - UIView configuration
    
    private func configureBackground() {
        view.backgroundColor = configuration?.backgroundColor
    }
    
    private func configureScrollView() {
        
    }
    
    private func configurePageControl() {
        
    }
    
    private func configureTermsAndConditionsLabel() {
        // TODO: NSLocalizedString
        let termsAndConditionsText: NSString = "Ved bruk av tjenesten Snapsale godtar du\rVilkårene for bruk og Retningslinjer for personvern"
        
        termsAndConditionsLabel?.setText(termsAndConditionsText, afterInheritingLabelAttributesAndConfiguringWithBlock: { (text) -> NSMutableAttributedString in
            if let gothamRoundedBook = SnapFonts.gothamRoundedBookOfSize(10) {
                text.addAttribute(NSFontAttributeName, value: gothamRoundedBook, range: text.mutableString.rangeOfString(text.string))
            }
            
            return text
        })
        
        if let gothamRoundedMedium = SnapFonts.gothamRoundedMediumOfSize(10) {
            termsAndConditionsLabel?.linkAttributes = [NSFontAttributeName : gothamRoundedMedium]
        }
        
        termsAndConditionsLabel?.activeLinkAttributes = nil
        
        let termsAndConditionsURL = NSURL(string: "https://snapsale.com/terms")
        let privacyPolicyURL = NSURL(string: "https://snapsale.com/privacy")
        
        let termsAndConditionsRange = termsAndConditionsText.rangeOfString("Vilkårene for bruk")
        let privacyPolicyRange = termsAndConditionsText.rangeOfString("Retningslinjer for personvern")
        
        termsAndConditionsLabel?.addLinkToURL(termsAndConditionsURL, withRange: termsAndConditionsRange)
        termsAndConditionsLabel?.addLinkToURL(privacyPolicyURL, withRange: privacyPolicyRange)
        
        termsAndConditionsLabel?.extendsLinkTouchArea = true
    }
    
    // MARK: - UIPageControl
    
    private func updatePageControl() {
        guard let scrollView = scrollView else {
            return
        }
        
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

// MARK: - TTTAttributedLabelDelegate

extension SnapOnboardingViewController: TTTAttributedLabelDelegate {
    
    public func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }
    
}
