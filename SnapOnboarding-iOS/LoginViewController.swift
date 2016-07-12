import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet private var continueWithFacebookButton: UIButton?
    @IBOutlet private var continueWithInstagramButton: UIButton?
    @IBOutlet private var skipLoginButton: UIButton?
    @IBOutlet private(set) var sparklingStars: [UIImageView]?
    
    @IBOutlet private var continueWithFacebookButtonWidth: NSLayoutConstraint?
    @IBOutlet private var continueWithInstagramButtonWidth: NSLayoutConstraint?
    @IBOutlet private var topSpacerHeight: NSLayoutConstraint?
    @IBOutlet private var skipLoginButtonBottomToSuperViewBottom: NSLayoutConstraint?
    
    @IBAction func continueWithFacebookButtonTapped(sender: UIButton) {
        delegate?.facebookSignupTapped()
    }
    
    @IBAction func continueWithInstagramButtonTapped(sender: UIButton) {
        delegate?.instagramSignupTapped()
    }
    
    @IBAction func skipLoginButtonTapped(sender: UIButton) {
        delegate?.skipLoginButtonTapped()
    }
    
    var delegate: LoginViewControllerDelegate?
    private var viewModel: SnapOnboardingViewModel.LoginViewModel?
    
    // MARK: UIViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(viewModel != nil)
        
        setupForScreenSize(SnapOnboardingViewController.screenSize)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureContinueWithFacebookButton()
        configureContinueWithInstagramButton()
        configureSkipLoginButton()
        alignFacebookAndInstagramButtons()
        
        let duration: NSTimeInterval = 2
        animateSparklingStarsWithCycleDuration(duration)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        setupForScreenSize(size)
    }
    
    // MARK: UIView configuration
    
    private func configureContinueWithFacebookButton() {
        continueWithFacebookButton?.setTitle(viewModel?.continueWithFacebook?.uppercaseString, forState: .Normal)
        let intrinsicContentWidth = continueWithFacebookButton?.intrinsicContentSize().width ?? 245
        let rightPadding: CGFloat = 25
        let requiredWidth = intrinsicContentWidth + rightPadding
        continueWithFacebookButtonWidth?.constant = requiredWidth
    }
    
    private func configureContinueWithInstagramButton() {
        continueWithInstagramButton?.setTitle(viewModel?.continueWithInstagram?.uppercaseString, forState: .Normal)
        let intrinsicContentWidth = continueWithInstagramButton?.intrinsicContentSize().width ?? 245
        let rightPadding: CGFloat = 25
        let requiredWidth = intrinsicContentWidth + rightPadding
        continueWithInstagramButtonWidth?.constant = requiredWidth
    }
    
    private func configureSkipLoginButton() {
        skipLoginButton?.setTitle(viewModel?.skipWithoutLogin, forState: .Normal)
    }
    
    private func alignFacebookAndInstagramButtons() {
        if let facebookWidth = continueWithFacebookButtonWidth?.constant, instagramWidth = continueWithInstagramButtonWidth?.constant {
            let difference = facebookWidth - instagramWidth
            if (-6 ... 6).contains(difference) {
                continueWithInstagramButtonWidth?.constant = facebookWidth
            }
        }
    }

}

extension LoginViewController: LoginViewControllerProtocol {
    
    func configureForViewModel(viewModel: SnapOnboardingViewModel.LoginViewModel) {
        self.viewModel = viewModel
    }
    
}

// MARK: - HasSparklingStars

extension LoginViewController: HasSparklingStars {}

// MARK: - ScreenSizesProtocol

extension LoginViewController {
    
    func setupFor3_5InchPortrait() {
        topSpacerHeight?.constant = 17
        
        skipLoginButtonBottomToSuperViewBottom?.constant = 0
    }
    
    func setupFor4_0InchPortrait() {
        topSpacerHeight?.constant = 27
    }
    
}

