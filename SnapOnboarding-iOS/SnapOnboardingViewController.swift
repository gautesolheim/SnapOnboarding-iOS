import UIKit
import TTTAttributedLabel
import SnapFonts_iOS

private enum TermsAndConditionsURL: String {
    case TermsAndConditions = "terms"
    case PrivacyPolicy = "privacy"
}

private enum EmbedSegueIdentifier: String {
    case IntroViewController = "introContainerViewEmbed"
    case LocationViewController = "locationContainerViewEmbed"
    case LoginViewController = "loginContainerViewEmbed"
}

public enum LocationServicesStatus {
    case NotYetRequested
    case Enabled
    case Disabled
}

public class SnapOnboardingViewController: UIViewController {
    
    @IBOutlet private var scrollView: UIScrollView?
    @IBOutlet private var pageControl: UIPageControl?
    @IBOutlet private var termsAndConditionsLabel: TTTAttributedLabel?
    
    private var delegate: SnapOnboardingDelegate?
    private var viewModel: SnapOnboardingViewModel?
    var locationServicesStatus: LocationServicesStatus = .NotYetRequested
    
    // MARK: UIViewController life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(viewModel != nil)
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTermsAndConditionsLabel()
    }
    
    private func dismiss() {
        delegate?.willDismiss()
        
        dismissViewControllerAnimated(true) {
            self.delegate?.didDismiss()
        }
    }
    
    // MARK: UIView configuration
    
    private func configureTermsAndConditionsLabel() {
        guard let termsViewModel = viewModel?.termsViewModel, termsAndConditionsText = termsViewModel.termsAndPrivacyFooter else {
            return
        }
        
        termsAndConditionsLabel?.setText(termsAndConditionsText, afterInheritingLabelAttributesAndConfiguringWithBlock: { (text) -> NSMutableAttributedString in
            if let gothamRoundedBook = SnapFonts.gothamRoundedBookOfSize(10) {
                text.addAttribute(NSFontAttributeName, value: gothamRoundedBook, range: text.mutableString.rangeOfString(text.string))
            }
            
            return text
        })
        
        if let gothamRoundedMedium = SnapFonts.gothamRoundedMediumOfSize(10) {
            termsAndConditionsLabel?.linkAttributes = [NSFontAttributeName : gothamRoundedMedium, NSForegroundColorAttributeName : UIColor.whiteColor()]
            termsAndConditionsLabel?.activeLinkAttributes = nil
        }
        
        if let termsIndexRange = termsViewModel.rangeOfTermsAndConditions, privacyIndexRange = termsViewModel.rangeOfPrivacyPolicy {
            let termsRange = termsAndConditionsText.startIndex.distanceTo(termsIndexRange.startIndex) ..< termsAndConditionsText.startIndex.distanceTo(termsIndexRange.endIndex)
            let privacyRange = termsAndConditionsText.startIndex.distanceTo(privacyIndexRange.startIndex) ..< termsAndConditionsText.startIndex.distanceTo(privacyIndexRange.endIndex)
            termsAndConditionsLabel?.addLinkToURL(NSURL(string: TermsAndConditionsURL.TermsAndConditions.rawValue), withRange: NSRange(termsRange))
            termsAndConditionsLabel?.addLinkToURL(NSURL(string: TermsAndConditionsURL.PrivacyPolicy.rawValue), withRange: NSRange(privacyRange))
        }
        
        termsAndConditionsLabel?.extendsLinkTouchArea = true
    }
    
    // MARK: UIScrollView
    
    private func scrollToNextPage() {
        if let scrollView = scrollView {
            var newOffset = scrollView.contentOffset
            newOffset.x += view.frame.width
            scrollView.setContentOffset(newOffset, animated: true)
        }
    }
    
    // MARK: UIPageControl
    
    private func updatePageControl() {
        guard let scrollView = scrollView else {
            return
        }
        
        pageControl?.currentPage = Int(round(scrollView.contentOffset.x / view.frame.width))
    }
    
    // MARK: UIContentContainer
    
    override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        let currentPage = pageControl?.currentPage ?? 0
        
        coordinator.animateAlongsideTransition({ _ in
            let newOffset = CGPoint(x: CGFloat(currentPage) * size.width, y: 0)
            self.scrollView?.setContentOffset(newOffset, animated: true)
            }, completion: nil)
    }
    
    // MARK: UIViewController properties
    
    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier, viewModel = viewModel else {
            return
        }
        
        switch identifier {
            case EmbedSegueIdentifier.IntroViewController.rawValue:
            let destinationViewController = segue.destinationViewController as? IntroViewController
            destinationViewController?.delegate = self
            destinationViewController?.configureForViewModel(viewModel.introViewModel)
            case EmbedSegueIdentifier.LocationViewController.rawValue:
            let destinationViewController = segue.destinationViewController as? LocationViewController
            destinationViewController?.delegate = self
            destinationViewController?.configureForViewModel(viewModel.locationViewModel)
            case EmbedSegueIdentifier.LoginViewController.rawValue:
            let destinationViewController = segue.destinationViewController as? LoginViewController
            destinationViewController?.delegate = self
            destinationViewController?.configureForViewModel(viewModel.loginViewModel)
        default: break
        }
    }
    
}

// MARK: - SnapOnboardingViewControllerProtocol

extension SnapOnboardingViewController: SnapOnboardingViewControllerProtocol {
    
    public func applyConfiguration(configuration: SnapOnboardingConfiguration) {
        self.delegate = configuration.delegate
        self.viewModel = configuration.viewModel
    }
    
    public func locationServicesStatusChanged(status: Bool) {
        switch status {
        case true:
            locationServicesStatus = .Enabled
        case false:
            locationServicesStatus = .Disabled
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
            case TermsAndConditionsURL.TermsAndConditions.rawValue:
            delegate?.termsAndConditionsTapped()
            case TermsAndConditionsURL.PrivacyPolicy.rawValue:
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