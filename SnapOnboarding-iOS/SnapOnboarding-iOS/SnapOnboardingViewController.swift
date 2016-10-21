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

open class SnapOnboardingViewController: UIViewController {
    
    @IBOutlet internal var scrollView: UIScrollView?
    @IBOutlet fileprivate var pageControl: UIPageControl?
    @IBOutlet fileprivate(set) var termsAndConditionsLabel: TTTAttributedLabel?
    
    @IBOutlet fileprivate var termsAndConditionsLabelBottomToSuperViewBottom: NSLayoutConstraint?
    @IBOutlet fileprivate var pageControlBottomToTermsAndConditionsTop: NSLayoutConstraint?
    
    fileprivate var delegate: SnapOnboardingDelegate?
    fileprivate var viewModel: SnapOnboardingViewModel?
    
    fileprivate var locationViewController: LocationViewControllerProtocol?
    fileprivate var loginViewController: LoginViewControllerProtocol?
    
    // MARK: UIViewController life cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(viewModel != nil)
        
        setupForScreenSize(SnapOnboardingViewController.screenSize)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.onboardingWillAppear()
        
        configureTermsAndConditionsLabel()

        startAnimations()
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        stopAnimations()
    }
    
    // MARK: UIView configuration
    
    internal func configureTermsAndConditionsLabel() {
        guard let termsViewModel = viewModel?.termsViewModel,
            let termsAndConditionsText = termsViewModel.termsAndPrivacyFooter else {
            return
        }
        
        termsAndConditionsLabel?.setText(termsAndConditionsText, afterInheritingLabelAttributesAndConfiguringWith: { (text) -> NSMutableAttributedString in
            guard let text = text else { return NSMutableAttributedString(string: "") }
            
            if let gothamRoundedBook = SnapFonts.gothamRoundedBookOfSize(10) {
                text.addAttribute(NSFontAttributeName, value: gothamRoundedBook, range: text.mutableString.range(of: text.string))
            }
            
            return text
        })
        
        if let gothamRoundedMedium = SnapFonts.gothamRoundedMediumOfSize(10) {
            termsAndConditionsLabel?.linkAttributes = [NSFontAttributeName : gothamRoundedMedium, NSForegroundColorAttributeName : UIColor.white]
            termsAndConditionsLabel?.activeLinkAttributes = [NSForegroundColorAttributeName : UIColor(red: 254/255.0, green: 232/255.0, blue: 5/255.0, alpha:1)]
            termsAndConditionsLabel?.inactiveLinkAttributes = nil
        }
        
        if let termsIndexRange = termsViewModel.rangeOfTermsAndConditions,
            let privacyIndexRange = termsViewModel.rangeOfPrivacyPolicy {
            let termsRange = termsAndConditionsText.characters.distance(from: termsAndConditionsText.startIndex, to: termsIndexRange.lowerBound) ..< termsAndConditionsText.characters.distance(from: termsAndConditionsText.startIndex, to: termsIndexRange.upperBound)
            let privacyRange = termsAndConditionsText.characters.distance(from: termsAndConditionsText.startIndex, to: privacyIndexRange.lowerBound) ..< termsAndConditionsText.characters.distance(from: termsAndConditionsText.startIndex, to: privacyIndexRange.upperBound)
            let _ = termsAndConditionsLabel?.addLink(to: URL(string: TermsAndConditionsURL.TermsAndConditions.rawValue), with: NSRange(Range(termsRange)))
            let _ = termsAndConditionsLabel?.addLink(to: URL(string: TermsAndConditionsURL.PrivacyPolicy.rawValue), with: NSRange(Range(privacyRange)))
        }
        
        termsAndConditionsLabel?.extendsLinkTouchArea = true
    }
    
    // MARK: UIScrollView
    
    fileprivate func scrollToNextPage() {
        if let scrollView = scrollView {
            var newOffset = scrollView.contentOffset
            newOffset.x += view.frame.width
            scrollView.setContentOffset(newOffset, animated: true)
        }
    }
    
    // MARK: UIPageControl
    
    fileprivate func updatePageControl() {
        guard let scrollView = scrollView else {
            return
        }
        
        pageControl?.currentPage = Int(round(scrollView.contentOffset.x / view.frame.width))
    }
    
    // MARK: UIContentContainer
    
    // Adjust scrollView's contentOffset on orientation change
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        setupForScreenSize(size)
        
        let currentPage = pageControl?.currentPage ?? 0
        coordinator.animate(alongsideTransition: { [weak self] _ in
            let newOffset = CGPoint(x: CGFloat(currentPage) * size.width, y: 0)
            self?.scrollView?.setContentOffset(newOffset, animated: true)
            }, completion: nil)
    }
    
    // MARK: UIViewController properties
    
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let viewModel = viewModel else {
            return
        }
        
        switch identifier {
            case EmbedSegueIdentifier.IntroViewController.rawValue:
            let destinationViewController = segue.destination as? IntroViewController
            destinationViewController?.delegate = self as IntroViewControllerDelegate
            destinationViewController?.configureForViewModel(viewModel.introViewModel)
            case EmbedSegueIdentifier.LocationViewController.rawValue:
            let destinationViewController = segue.destination as? LocationViewController
            destinationViewController?.delegate = self as LocationViewControllerDelegate
            destinationViewController?.configureForViewModel(viewModel.locationViewModel)
            locationViewController = destinationViewController
            case EmbedSegueIdentifier.LoginViewController.rawValue:
            let destinationViewController = segue.destination as? LoginViewController
            destinationViewController?.delegate = self as LoginViewControllerDelegate
            destinationViewController?.configureForViewModel(viewModel.loginViewModel)
            loginViewController = destinationViewController
        default: break
        }
    }
    
}

// MARK: - SnapOnboardingViewControllerProtocol

extension SnapOnboardingViewController: SnapOnboardingViewControllerProtocol {
    
    public func applyConfiguration(_ configuration: SnapOnboardingConfiguration) {
        delegate = configuration.delegate
        viewModel = configuration.viewModel
    }

    public func applyFormerAuthorizationService(_ service: AuthorizationService, userViewModel: UserViewModel) {
        assert(service != .none)

        loginViewController?.applyFormerAuthorizationService(service, userViewModel: userViewModel)
    }
    
    public func locationServicesStatusChanged(_ status: LocationServicesStatus) {
        assert(status == .enabled || status == .disabled)
        
        locationViewController?.locationServicesStatusChanged(status)
        
        if status == .enabled {
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePageControl()
    }
    
}

// MARK: - TTTAttributedLabelDelegate

extension SnapOnboardingViewController: TTTAttributedLabelDelegate {
    
    public func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        let absoluteString = url.absoluteString
        
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
    
    func logoutFromCurrentAccountTapped() {
        delegate?.logoutFromCurrentAccountTapped()
    }
    
}

// MARK: - ScreenSizesProtocol

extension SnapOnboardingViewController {
    
    func setupFor3_5InchPortrait() {
        pageControlBottomToTermsAndConditionsTop?.constant = 11
        termsAndConditionsLabelBottomToSuperViewBottom?.constant = 11
    }
    
}
