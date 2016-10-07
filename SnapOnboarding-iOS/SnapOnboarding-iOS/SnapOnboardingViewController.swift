import UIKit
import TTTAttributedLabel
import SnapFonts_iOS

private enum TermsAndConditionsURL: String {
    case TermsAndConditions = "terms"
    case PrivacyPolicy = "privacy"
}

private enum EmbedSegueIdentifier: String {
    case IntroViewController = "IntroContainerViewEmbed"
    case LocationViewController = "LocationContainerViewEmbed"
    case LoginViewController = "LoginContainerViewEmbed"
}

public class SnapOnboardingViewController: UIViewController {
    
    @IBOutlet internal var scrollView: UIScrollView?
    @IBOutlet private var pageControl: UIPageControl?
    @IBOutlet private(set) var termsAndConditionsLabel: TTTAttributedLabel?
    
    @IBOutlet private var termsAndConditionsLabelBottomToSuperViewBottom: NSLayoutConstraint?
    @IBOutlet private var pageControlBottomToTermsAndConditionsTop: NSLayoutConstraint?
    
    private var delegate: SnapOnboardingDelegate?
    private var viewModel: SnapOnboardingViewModel?
    
    private var locationViewController: LocationViewControllerProtocol?
    private var loginViewController: LoginViewControllerProtocol?
    
    // MARK: UIViewController life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(viewModel != nil)
        
        setupForScreenSize(SnapOnboardingViewController.screenSize)
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.onboardingWillAppear()
        
        configureTermsAndConditionsLabel()

        startAnimations()
    }

    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        stopAnimations()
    }
    
    // MARK: UIView configuration
    
    internal func configureTermsAndConditionsLabel() {
        guard let termsViewModel = viewModel?.termsViewModel,
            let termsAndConditionsText = termsViewModel.termsAndPrivacyFooter else {
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
            termsAndConditionsLabel?.activeLinkAttributes = [NSForegroundColorAttributeName : UIColor(red: 254/255.0, green: 232/255.0, blue: 5/255.0, alpha:1)]
            termsAndConditionsLabel?.inactiveLinkAttributes = nil
        }
        
        if let termsIndexRange = termsViewModel.rangeOfTermsAndConditions,
            let privacyIndexRange = termsViewModel.rangeOfPrivacyPolicy {
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
    
    // Adjust scrollView's contentOffset on orientation change
    override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        setupForScreenSize(size)
        
        let currentPage = pageControl?.currentPage ?? 0
        coordinator.animateAlongsideTransition({ [weak self] _ in
            let newOffset = CGPoint(x: CGFloat(currentPage) * size.width, y: 0)
            self?.scrollView?.setContentOffset(newOffset, animated: true)
            }, completion: nil)
    }
    
    // MARK: UIViewController properties
    
    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier,
            let viewModel = viewModel else {
            return
        }
        
        switch identifier {
            case EmbedSegueIdentifier.IntroViewController.rawValue:
            let destinationViewController = segue.destinationViewController as? IntroViewController
            destinationViewController?.delegate = self as IntroViewControllerDelegate
            destinationViewController?.configureForViewModel(viewModel.introViewModel)
            case EmbedSegueIdentifier.LocationViewController.rawValue:
            let destinationViewController = segue.destinationViewController as? LocationViewController
            destinationViewController?.delegate = self as LocationViewControllerDelegate
            destinationViewController?.configureForViewModel(viewModel.locationViewModel)
            locationViewController = destinationViewController
            case EmbedSegueIdentifier.LoginViewController.rawValue:
            let destinationViewController = segue.destinationViewController as? LoginViewController
            destinationViewController?.delegate = self as LoginViewControllerDelegate
            destinationViewController?.configureForViewModel(viewModel.loginViewModel)
            loginViewController = destinationViewController
        default: break
        }
    }
    
}

// MARK: - SnapOnboardingViewControllerProtocol

extension SnapOnboardingViewController: SnapOnboardingViewControllerProtocol {
    
    public func applyConfiguration(configuration: SnapOnboardingConfiguration) {
        delegate = configuration.delegate
        viewModel = configuration.viewModel
    }

    public func applyFormerAuthorizationService(service: AuthorizationService, userViewModel: UserViewModel) {
        assert(service != .None)

        loginViewController?.applyFormerAuthorizationService(service, userViewModel: userViewModel)
    }
    
    public func locationServicesStatusChanged(status: LocationServicesStatus) {
        assert(status == .Enabled || status == .Disabled)
        
        locationViewController?.locationServicesStatusChanged(status)
        
        if status == .Enabled {
            scrollToNextPage()
        }
    }
    
    public func reactivateLoginButtons() {
        if let loginViewController = loginViewController {
            loginViewController.reactivateLoginButtons()
        }
    }


    public func startAnimations() {
        childViewControllers.forEach { ($0 as? HasSparklingStars)?.animateSparklingStarsWithCycleDuration(2.0) }
    }

    public func stopAnimations() {
        childViewControllers.forEach { ($0 as? HasSparklingStars)?.stopAnimatingSparklingStars() }
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
        guard let absoluteString = url.absoluteString else { return }
        
        switch absoluteString {
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
    
    func locationServicesInstructionsTapped() {
        delegate?.locationServicesInstructionsTapped()
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

    func continueAsLoggedInUserTapped() {
        delegate?.continueAsLoggedInUserTapped()
    }
    
    func skipLoginTapped() {
        delegate?.skipLoginTapped()
    }
    
}

// MARK: - ScreenSizesProtocol

extension SnapOnboardingViewController {
    
    func setupFor3_5InchPortrait() {
        pageControlBottomToTermsAndConditionsTop?.constant = 11
        termsAndConditionsLabelBottomToSuperViewBottom?.constant = 11
    }
    
}
