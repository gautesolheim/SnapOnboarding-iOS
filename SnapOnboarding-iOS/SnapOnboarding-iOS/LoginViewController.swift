import UIKit
import SnapFonts_iOS
import Haneke

class LoginViewController: UIViewController {

    @IBOutlet fileprivate var snapsaleLogo: UIImageView?
    @IBOutlet fileprivate(set) var continueWithFacebookButton: UIButton?
    @IBOutlet fileprivate(set) var continueWithInstagramButton: UIButton?
    @IBOutlet fileprivate(set) var skipLoginButton: UIButton?

    @IBOutlet fileprivate var profilePhoto: UIImageView?
    @IBOutlet fileprivate var socialLogoMask: UIImageView?
    @IBOutlet fileprivate var welcomeBackLabel: UILabel?
    @IBOutlet fileprivate(set) var continueAsLoggedInUserButton: UIButton?
    @IBOutlet fileprivate(set) var changeAccountButton: UIButton?

    @IBOutlet fileprivate var star7: UIImageView?
    @IBOutlet fileprivate var star6CenterY: NSLayoutConstraint?
    @IBOutlet fileprivate var welcomeBackLabelCenterY: NSLayoutConstraint?

    @IBOutlet fileprivate(set) var sparklingStars: [UIImageView]?
    
    @IBOutlet fileprivate var topSpacerHeight: NSLayoutConstraint?
    @IBOutlet fileprivate var sparklingContinueSpacerToTopSpacerHeightRelation: NSLayoutConstraint?
    @IBOutlet fileprivate var continueWithFacebookButtonWidth: NSLayoutConstraint?
    @IBOutlet fileprivate var continueWithInstagramButtonWidth: NSLayoutConstraint?
    @IBOutlet fileprivate var skipLoginButtonBottomToSuperViewBottom: NSLayoutConstraint?

    var delegate: LoginViewControllerDelegate?
    fileprivate var viewModel: SnapOnboardingViewModel.LoginViewModel?

    fileprivate var formerAuthorizationService: AuthorizationService = .none
    fileprivate var userViewModel: UserViewModel?
    
    @IBAction func continueWithFacebookButtonTapped(_ sender: UIButton) {
        delegate?.facebookSignupTapped()
        fadeAndDisableButtonsExceptTappedButton(sender)
    }
    
    @IBAction func continueWithInstagramButtonTapped(_ sender: UIButton) {
        delegate?.instagramSignupTapped()
        fadeAndDisableButtonsExceptTappedButton(sender)
    }

    @IBAction func continueAsLoggedInUserButtonTapped(_ sender: UIButton) {
        delegate?.continueAsLoggedInUserTapped()
        fadeAndDisableButtonsExceptTappedButton(sender)
    }
    
    @IBAction func skipLoginButtonTapped(_ sender: UIButton) {
        delegate?.skipLoginTapped()
        fadeAndDisableButtonsExceptTappedButton(sender)
    }

    @IBAction func changeAccountButtonTapped(_ sender: UIButton) {
        delegate?.logoutFromCurrentAccountTapped()
        switchWelcomeBackHidden(hidden: true)
    }
    
    // MARK: UIViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(viewModel != nil)
        
        setupForScreenSize(SnapOnboardingViewController.screenSize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureContinueWithFacebookButton()
        configureContinueWithInstagramButton()
        configureSkipLoginButton()
        alignFacebookAndInstagramButtons()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            self.updateProfileViewCornerRadius()
        }, completion: nil)
        
        setupForScreenSize(size)
    }
    
    // MARK: UIView configuration
    
    fileprivate func configureContinueWithFacebookButton() {
        continueWithFacebookButton?.setTitle(viewModel?.continueWithFacebook?.uppercased(), for: UIControlState())
        let intrinsicContentWidth = continueWithFacebookButton?.intrinsicContentSize.width ?? 245
        let rightPadding: CGFloat = 25
        let requiredWidth = intrinsicContentWidth + rightPadding
        continueWithFacebookButtonWidth?.constant = requiredWidth
    }
    
    fileprivate func configureContinueWithInstagramButton() {
        continueWithInstagramButton?.setTitle(viewModel?.continueWithInstagram?.uppercased(), for: UIControlState())
        let intrinsicContentWidth = continueWithInstagramButton?.intrinsicContentSize.width ?? 245
        let rightPadding: CGFloat = 25
        let requiredWidth = intrinsicContentWidth + rightPadding
        continueWithInstagramButtonWidth?.constant = requiredWidth
    }
    
    fileprivate func configureSkipLoginButton() {
        skipLoginButton?.setTitle(viewModel?.skipWithoutLogin, for: UIControlState())
    }
    
    fileprivate func alignFacebookAndInstagramButtons() {
        if let facebookWidth = continueWithFacebookButtonWidth?.constant,
           let instagramWidth = continueWithInstagramButtonWidth?.constant {
            let difference = facebookWidth - instagramWidth
            if (-6 ... 6).contains(difference) {
                continueWithInstagramButtonWidth?.constant = facebookWidth
            }
        }
    }
    
    fileprivate func fadeAndDisableButtonsExceptTappedButton(_ tappedButton: UIButton) {
        
        let buttonsToDeactivate = [continueWithFacebookButton, continueWithInstagramButton, changeAccountButton, skipLoginButton]
        let buttonsToFade = buttonsToDeactivate.filter { $0 != tappedButton }
        
        buttonsToDeactivate.forEach { button in
            button?.isUserInteractionEnabled = false
        }
        
        buttonsToFade.forEach { button in
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
                button?.alpha = 0.3
            }, completion: nil)
        }
        
    }

    // MARK: UIView configuration for previously authorized users

    fileprivate func configureForPreviouslyAuthorizedUser() {
        configureProfileView()
        configureContinueAsLoggedInUserButton()
        configureChangeAccountButton()

        switchWelcomeBackHidden(hidden: false)
    }

    fileprivate func configureProfileView() {
        welcomeBackLabel?.text = viewModel?.welcomeBack
        profilePhoto?.layer.masksToBounds = true
        updateProfileViewCornerRadius()

        if let profilePhoto = profilePhoto,
            let url = userViewModel?.profileImageURL?.withSize(profilePhoto.bounds.size) {

            profilePhoto.hnk_setImageFromURL(url)
        }
        
        if case .facebook = formerAuthorizationService {
            socialLogoMask?.image = Asset.Avatar_Facebook.image
        } else if case .instagram = formerAuthorizationService {
            socialLogoMask?.image = Asset.Avatar_Instagram.image
        }
    }

    func updateProfileViewCornerRadius() {
        profilePhoto?.layer.cornerRadius = (profilePhoto?.frame.size.height ?? 69) / 2.0
    }

    fileprivate func configureContinueAsLoggedInUserButton() {
        continueAsLoggedInUserButton?.setTitle(viewModel?.continve?.uppercased(), for: UIControlState())
    }

    fileprivate func configureChangeAccountButton() {
        let title = self.viewModel?.logInWithAnotherAccount
        UIView.performWithoutAnimation {
            self.changeAccountButton?.setTitle(title, for: UIControlState())
            self.changeAccountButton?.layoutIfNeeded()
        }
    }

    fileprivate func switchWelcomeBackHidden(hidden welcomeBackHidden: Bool) {
        let welcomeBackViews: [UIView?] = [profilePhoto, socialLogoMask, welcomeBackLabel, continueAsLoggedInUserButton, changeAccountButton]
        let newUserViews: [UIView?] = [snapsaleLogo, continueWithFacebookButton, continueWithInstagramButton, skipLoginButton]

        welcomeBackViews.forEach { $0?.isHidden = false }
        newUserViews.forEach { $0?.isHidden = false }
        
        UIView.animate(withDuration: 0.2, animations: {
            welcomeBackViews.forEach { $0?.alpha = welcomeBackHidden ? 0 : 1 }
            newUserViews.forEach { $0?.alpha = welcomeBackHidden ? 1 : 0 }
        }, completion: { finished in
            // The animations may be interrupted if the protocol method calling this method is called several times
            guard finished else { return }

            if welcomeBackHidden {
                welcomeBackViews.forEach { $0?.isHidden = true }
            } else {
                newUserViews.forEach { $0?.isHidden = true }
            }
        })
    }

}

// MARK: - LoginViewControllerProtocol

extension LoginViewController: LoginViewControllerProtocol {
    
    func configureForViewModel(_ viewModel: SnapOnboardingViewModel.LoginViewModel) {
        self.viewModel = viewModel
    }

    func applyFormerAuthorizationService(_ formerAuthorizationService: AuthorizationService, userViewModel: UserViewModel) {
        assert(formerAuthorizationService != .none)

        self.formerAuthorizationService = formerAuthorizationService
        self.userViewModel = userViewModel

        configureForPreviouslyAuthorizedUser()
    }
    
    func reactivateLoginButtons() {
        let buttonsToReactivate = [continueWithFacebookButton, continueWithInstagramButton, changeAccountButton, skipLoginButton]
        
        buttonsToReactivate.forEach { button in
            button?.isUserInteractionEnabled = true
            
            if button?.alpha != 1.0 {
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
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
        welcomeBackLabel?.numberOfLines = 3
        welcomeBackLabel?.font = SnapFonts.gothamRoundedMediumOfSize(14)

        star7?.isHidden = true
        star6CenterY?.constant = 8
        welcomeBackLabelCenterY?.constant = 5

        skipLoginButtonBottomToSuperViewBottom?.constant = 0
    }
    
    func setupFor4_0InchPortrait() {
        topSpacerHeight?.constant = 27
    }
    
    func setupFor5_5InchPortrait() {
        topSpacerHeight?.constant = 50
    }
    
    func setupForIpadPortrait(_ size: CGSize) {
        topSpacerHeight?.constant = 150
        
        if size.width <= 320 {
            topSpacerHeight?.constant = 210
        }
    }
    
    func setupForIpadLandscape(_ size: CGSize) {
        topSpacerHeight?.constant = 60
        
        if size.width <= 320 {
            topSpacerHeight?.constant = 120
        }
    }
    
    func setupForIpadProPortrait(_ size: CGSize) {
        topSpacerHeight?.constant = 250
        
        if size.width <= 375 {
            topSpacerHeight?.constant = 360
        }
    }
    
    func setupForIpadProLandscape(_ size: CGSize) {
        topSpacerHeight?.constant = 140
        
        if size.width <= 375 {
            topSpacerHeight?.constant = 270
        }
    }
    
}
