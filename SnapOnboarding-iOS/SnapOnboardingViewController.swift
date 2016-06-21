import UIKit
import TTTAttributedLabel
import SnapFonts_iOS

public class SnapOnboardingViewController: UIViewController {
    
    @IBOutlet private var scrollView: UIScrollView?
    @IBOutlet private var pageControl: UIPageControl?
    @IBOutlet private var termsAndConditionsLabel: TTTAttributedLabel?
    
    private var backgroundColor: UIColor?
    private var delegate: SnapOnboardingDelegate?
    private var stringsViewModel: SnapOnboardingStringsViewModel?
    
    public func applyConfiguration(configuration: SnapOnboardingConfiguration) {
        self.delegate = configuration.delegate
        self.stringsViewModel = configuration.stringsViewModel
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(stringsViewModel != nil)
        
        configureTermsAndConditionsLabel()
    }
    
    // MARK: - UIView configuration
    
    private func configureTermsAndConditionsLabel() {
        guard let stringsViewModel = stringsViewModel, termsAndConditionsText = stringsViewModel.termsAndPrivacyFooter else {
            return
        }
        
        termsAndConditionsLabel?.setText(termsAndConditionsText, afterInheritingLabelAttributesAndConfiguringWithBlock: { (text) -> NSMutableAttributedString in
            if let gothamRoundedBook = SnapFonts.gothamRoundedBookOfSize(10) {
                text.addAttribute(NSFontAttributeName, value: gothamRoundedBook, range: text.mutableString.rangeOfString(text.string))
            }
            
            return text
        })
        
        if let gothamRoundedMedium = SnapFonts.gothamRoundedMediumOfSize(10) {
            termsAndConditionsLabel?.linkAttributes = [NSFontAttributeName : gothamRoundedMedium]
            termsAndConditionsLabel?.activeLinkAttributes = nil
        }
        
        if let termsIndexRange = stringsViewModel.rangeOfTermsAndConditions, privacyIndexRange = stringsViewModel.rangeOfPrivacyPolicy {
            let termsRange = termsAndConditionsText.startIndex.distanceTo(termsIndexRange.startIndex) ..< termsAndConditionsText.startIndex.distanceTo(termsIndexRange.endIndex)
            let privacyRange = termsAndConditionsText.startIndex.distanceTo(privacyIndexRange.startIndex) ..< termsAndConditionsText.startIndex.distanceTo(privacyIndexRange.endIndex)
            termsAndConditionsLabel?.addLinkToURL(NSURL(string: "terms"), withRange: NSRange(termsRange))
            termsAndConditionsLabel?.addLinkToURL(NSURL(string: "privacy"), withRange: NSRange(privacyRange))
        }
        
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
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier, stringsViewModel = stringsViewModel else {
            return
        }
        
        switch identifier {
            case "introContainerViewEmbed":
            (segue.destinationViewController as? IntroViewController)?.applyStrings(stringsViewModel)
            case "locationContainerViewEmbed":
            (segue.destinationViewController as? LocationViewController)?.applyStrings(stringsViewModel)
            case "loginContainerViewEmbed":
            (segue.destinationViewController as? LoginViewController)?.applyStrings(stringsViewModel)
        default: break
        }
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
