import UIKit
import TTTAttributedLabel
import SnapFonts_iOS

public class SnapOnboardingViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet var pageControl: UIPageControl?
    @IBOutlet var termsAndConditionsLabel: TTTAttributedLabel?
    
    private var backgroundColor: UIColor?
    private var delegate: SnapOnboardingDelegate?
    
    public func applyConfiguration(configuration: SnapOnboardingConfiguration) {
        self.backgroundColor = configuration.backgroundColor
        self.delegate = configuration.delegate
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(backgroundColor != nil)
        
        configureBackground()
        configureTermsAndConditionsLabel()
    }
    
    // MARK: - UIView configuration
    
    private func configureBackground() {
        view.backgroundColor = backgroundColor
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
        
        let termsAndConditionsRange = termsAndConditionsText.rangeOfString("Vilkårene for bruk")
        let privacyPolicyRange = termsAndConditionsText.rangeOfString("Retningslinjer for personvern")
        
        termsAndConditionsLabel?.addLinkToURL(NSURL(string: "terms"), withRange: termsAndConditionsRange)
        termsAndConditionsLabel?.addLinkToURL(NSURL(string: "privacy"), withRange: privacyPolicyRange)
        
        termsAndConditionsLabel?.extendsLinkTouchArea = true
    }
    
    // MARK: - UIPageControl
    
    private func updatePageControl() {
        guard let scrollView = scrollView else {
            return
        }

//        Uncomment for Home Screen-like delayed updating
//        let viewWidth = view.frame.width
//        
//        switch scrollView.contentOffset.x {
//        case 0:
//            pageControl?.currentPage = 0
//        case viewWidth:
//            pageControl?.currentPage = 1
//        case viewWidth * 2:
//            pageControl?.currentPage = 2
//        default: break
//        }
        
        pageControl?.currentPage = Int(round(scrollView.contentOffset.x / view.frame.width))
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
        switch url.absoluteString {
            case "terms":
            delegate?.termsAndConditionsTapped()
            case "privacy":
            delegate?.privacyPolicyTapped()
        default: break
        }
    }
    
}

// MARK: IntroViewControllerDelegate

extension SnapOnboardingViewController: IntroViewControllerDelegate {
    
    func nextButtonTapped() {
        // TODO: Scroll to LocationViewController
    }
    
}
