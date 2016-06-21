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
    
    // MARK: - UIViewController life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(stringsViewModel != nil)
        
        configureTermsAndConditionsLabel()
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //dismiss()
    }
    
    private func dismiss() {
        delegate?.willDismiss()
        
        dismissViewControllerAnimated(true) {
            self.delegate?.didDismiss()
        }
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
    
    // MARK: - UIScrollView
    
    private func scrollToNextPage() {
        if let scrollView = scrollView {
            var newOffset = scrollView.contentOffset
            newOffset.x += view.frame.width
            scrollView.setContentOffset(newOffset, animated: true)
        }
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
            let destinationViewController = segue.destinationViewController as? IntroViewController
            destinationViewController?.delegate = self
            destinationViewController?.applyStrings(stringsViewModel)
            case "locationContainerViewEmbed":
            let destinationViewController = segue.destinationViewController as? LocationViewController
            destinationViewController?.delegate = self
            destinationViewController?.applyStrings(stringsViewModel)
            case "loginContainerViewEmbed":
            let destinationViewController = segue.destinationViewController as? LoginViewController
            destinationViewController?.delegate = self
            destinationViewController?.applyStrings(stringsViewModel)
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

// MARK: - IntroViewControllerDelegate

extension SnapOnboardingViewController: IntroViewControllerDelegate {
    
    func introNextButtonTapped() {
        scrollToNextPage()
    }
    
}

// MARK: - LocationViewControllerDelegate

extension SnapOnboardingViewController: LocationViewControllerDelegate {
    
    func locationNextButtonTapped() {
        scrollToNextPage()
    }
    
    func enableLocationServicesTapped() {
        delegate?.enableLocationServicesTapped()
    }
    
}

// MARK: - LoginViewControllerDelegate

extension SnapOnboardingViewController: LoginViewControllerDelegate {
    
    func facebookSignupTapped() {
        delegate?.facebookSignupTapped()
    }
    
    func instagramSignupTapped() {
        delegate?.instagramSignupTapped()
    }
    
    func skipLoginButtonTapped() {
        dismiss()
    }
    
}