import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private var snapsaleLogo: UIImageView?
    @IBOutlet private(set) var continueWithFacebookButton: UIButton?
    @IBOutlet private(set) var continueWithInstagramButton: UIButton?
    @IBOutlet private(set) var skipLoginButton: UIButton?

    @IBOutlet private var profilePhoto: UIImageView?
    @IBOutlet private var socialLogoMask: UIImageView?
    @IBOutlet private var welcomeBackLabel: UILabel?
    @IBOutlet private var continueAsLoggedInUserButton: UIButton?
    @IBOutlet private var changeAccountButton: UIButton?

    @IBOutlet private(set) var sparklingStars: [UIImageView]?
    
    @IBOutlet private var topSpacerHeight: NSLayoutConstraint?
    @IBOutlet private var sparklingContinueSpacerToTopSpacerHeightRelation: NSLayoutConstraint?
    @IBOutlet private var continueWithFacebookButtonWidth: NSLayoutConstraint?
    @IBOutlet private var continueWithInstagramButtonWidth: NSLayoutConstraint?
    @IBOutlet private var skipLoginButtonBottomToSuperViewBottom: NSLayoutConstraint?

    var delegate: LoginViewControllerDelegate?
    private var viewModel: SnapOnboardingViewModel.LoginViewModel?

    private var formerAuthorizationService: AuthorizationService = .None
    private var userViewModel: UserViewModel?
    
    @IBAction func continueWithFacebookButtonTapped(sender: UIButton) {
        delegate?.facebookSignupTapped()
        fadeAndDisableButtonsExceptTappedButton(sender)
    }
    
    @IBAction func continueWithInstagramButtonTapped(sender: UIButton) {
        delegate?.instagramSignupTapped()
        fadeAndDisableButtonsExceptTappedButton(sender)
    }

    @IBAction func continueAsLoggedInUserButtonTapped(sender: UIButton) {
        delegate?.continueAsLoggedInUserTapped()
        fadeAndDisableButtonsExceptTappedButton(sender)
    }
    
    @IBAction func skipLoginButtonTapped(sender: UIButton) {
        delegate?.skipLoginTapped()
        fadeAndDisableButtonsExceptTappedButton(sender)
    }

    @IBAction func changeAccountButtonTapped(sender: UIButton) {
        switchWelcomeBackHidden(hidden: true)
    }
    
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
        
        animateSparklingStarsWithCycleDuration(2)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        sparklingStars?.forEach { $0.layer.removeAllAnimations() }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        coordinator.animateAlongsideTransition({ _ in
            self.updateProfileViewCornerRadius()
        }, completion: nil)
        
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
    
    private func fadeAndDisableButtonsExceptTappedButton(tappedButton: UIButton) {
        
        let buttonsToDeactivate = [continueWithFacebookButton, continueWithInstagramButton, changeAccountButton, skipLoginButton]
        let buttonsToFade = buttonsToDeactivate.filter { $0 != tappedButton }
        
        buttonsToDeactivate.forEach { button in
            button?.userInteractionEnabled = false
        }
        
        buttonsToFade.forEach { button in
            UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseIn, animations: {
                button?.alpha = 0.3
            }, completion: nil)
        }
        
    }

    // MARK: UIView configuration for previously authorized users

    private func configureForPreviouslyAuthorizedUser() {
        configureProfileView()
        configureContinueAsLoggedInUserButton()
        configureChangeAccountButton()

        switchWelcomeBackHidden(hidden: false)
    }

    private func configureProfileView() {
        welcomeBackLabel?.text = viewModel?.welcomeBack
        profilePhoto?.layer.masksToBounds = true
        updateProfileViewCornerRadius()
        profilePhoto?.image = userViewModel?.profileImage

        if case .Facebook = formerAuthorizationService {
            socialLogoMask?.image = Asset.Avatar_Facebook.image
        } else if case .Instagram = formerAuthorizationService {
            socialLogoMask?.image = Asset.Avatar_Instagram.image
        }
    }

    func updateProfileViewCornerRadius() {
        profilePhoto?.layer.cornerRadius = (profilePhoto?.frame.size.height ?? 69) / 2.0
    }

    private func configureContinueAsLoggedInUserButton() {
        continueAsLoggedInUserButton?.setTitle(viewModel?.continve?.uppercaseString, forState: .Normal)
    }

    private func configureChangeAccountButton() {
        let title = self.viewModel?.logInWithAnotherAccount
        UIView.performWithoutAnimation {
            self.changeAccountButton?.setTitle(title, forState: .Normal)
            self.changeAccountButton?.layoutIfNeeded()
        }
    }

    private func switchWelcomeBackHidden(hidden welcomeBackHidden: Bool) {
        let welcomeBackViews: [UIView?] = [profilePhoto, socialLogoMask, welcomeBackLabel, continueAsLoggedInUserButton, changeAccountButton]
        let newUserViews: [UIView?] = [snapsaleLogo, continueWithFacebookButton, continueWithInstagramButton, skipLoginButton]
        
        welcomeBackViews.forEach { $0?.hidden = false }
        newUserViews.forEach { $0?.hidden = false }
        
        UIView.animateWithDuration(0.2, animations: {
            welcomeBackViews.forEach { $0?.alpha = welcomeBackHidden ? 0 : 1 }
            newUserViews.forEach { $0?.alpha = welcomeBackHidden ? 1 : 0 }
        }, completion: { _ in
            if welcomeBackHidden {
                welcomeBackViews.forEach { $0?.hidden = true }
            } else {
                newUserViews.forEach { $0?.hidden = true }
            }
        })

    }

}

// MARK: - LoginViewControllerProtocol

extension LoginViewController: LoginViewControllerProtocol {
    
    func configureForViewModel(viewModel: SnapOnboardingViewModel.LoginViewModel) {
        self.viewModel = viewModel
    }

    func applyFormerAuthorizationService(formerAuthorizationService: AuthorizationService, userViewModel: UserViewModel) {
        assert(formerAuthorizationService != .None)

        self.formerAuthorizationService = formerAuthorizationService
        self.userViewModel = userViewModel

        configureForPreviouslyAuthorizedUser()
    }
    
    func reactivateLoginButtons() {
        let buttonsToReactivate = [continueWithFacebookButton, continueWithInstagramButton, changeAccountButton, skipLoginButton]
        
        buttonsToReactivate.forEach { button in
            button?.userInteractionEnabled = true
            
            if button?.alpha != 1.0 {
                UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseIn, animations: {
                    button?.alpha = 1.0
                }, completion: nil)
            }
        }
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
    
    func setupFor5_5InchPortrait() {
        topSpacerHeight?.constant = 50
    }
    
    func setupForIpadPortrait(size: CGSize) {
        topSpacerHeight?.constant = 150
        
        if size.width <= 320 {
            topSpacerHeight?.constant = 210
        }
    }
    
    func setupForIpadLandscape(size: CGSize) {
        topSpacerHeight?.constant = 60
        
        if size.width <= 320 {
            topSpacerHeight?.constant = 120
        }
    }
    
    func setupForIpadProPortrait(size: CGSize) {
        topSpacerHeight?.constant = 250
        
        if size.width <= 375 {
            topSpacerHeight?.constant = 360
        }
    }
    
    func setupForIpadProLandscape(size: CGSize) {
        topSpacerHeight?.constant = 140
        
        if size.width <= 375 {
            topSpacerHeight?.constant = 270
        }
    }
    
}

