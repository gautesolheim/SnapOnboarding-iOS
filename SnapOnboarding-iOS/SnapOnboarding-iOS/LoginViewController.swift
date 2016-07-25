import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet private(set) var continueWithFacebookButton: UIButton?
    @IBOutlet private(set) var continueWithInstagramButton: UIButton?
    @IBOutlet private(set) var skipLoginButton: UIButton?
    @IBOutlet private(set) var sparklingStars: [UIImageView]?
    
    @IBOutlet private var topSpacerHeight: NSLayoutConstraint?
    @IBOutlet private var sparklingContinueSpacerToTopSpacerHeightRelation: NSLayoutConstraint?
    @IBOutlet private var continueWithFacebookButtonWidth: NSLayoutConstraint?
    @IBOutlet private var continueWithInstagramButtonWidth: NSLayoutConstraint?
    @IBOutlet private var skipLoginButtonBottomToSuperViewBottom: NSLayoutConstraint?
    
    @IBAction func continueWithFacebookButtonTapped(sender: UIButton) {
        delegate?.facebookSignupTapped()
        fadeAndDisableButtonsExceptTappedButton(sender)
    }
    
    @IBAction func continueWithInstagramButtonTapped(sender: UIButton) {
        delegate?.instagramSignupTapped()
        fadeAndDisableButtonsExceptTappedButton(sender)
    }
    
    @IBAction func skipLoginButtonTapped(sender: UIButton) {
        delegate?.skipLoginTapped()
        fadeAndDisableButtonsExceptTappedButton(sender)
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
        
        animateSparklingStarsWithCycleDuration(2)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        sparklingStars?.forEach { $0.layer.removeAllAnimations() }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        setupForScreenSize(size)
    }
    
    // MARK: UIView configuration
    
    private func configureContinueWithFacebookButton() {
        guard let title = viewModel?.continueWithFacebook?.uppercaseString else {
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.18
        
        let attributedText = NSAttributedString(string: title, attributes: [NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : UIColor.blackColor()])
        UIView.performWithoutAnimation {
            self.continueWithFacebookButton?.setAttributedTitle(attributedText, forState: .Normal)
            self.continueWithFacebookButton?.layoutIfNeeded()
        }
        
        let intrinsicContentWidth = continueWithFacebookButton?.intrinsicContentSize().width ?? 245
        let rightPadding: CGFloat = 25
        let requiredWidth = intrinsicContentWidth + rightPadding
        continueWithFacebookButtonWidth?.constant = requiredWidth
    }
    
    private func configureContinueWithInstagramButton() {
        guard let title = viewModel?.continueWithInstagram?.uppercaseString else {
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.18
        
        let attributedText = NSAttributedString(string: title, attributes: [NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : UIColor.blackColor()])
        UIView.performWithoutAnimation {
            self.continueWithInstagramButton?.setAttributedTitle(attributedText, forState: .Normal)
            self.continueWithInstagramButton?.layoutIfNeeded()
        }

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
        
        let buttonsToDeactivate = [continueWithFacebookButton, continueWithInstagramButton, skipLoginButton]
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

}

// MARK: - LoginViewControllerProtocol

extension LoginViewController: LoginViewControllerProtocol {
    
    func configureForViewModel(viewModel: SnapOnboardingViewModel.LoginViewModel) {
        self.viewModel = viewModel
    }
    
    func reactivateLoginButtons() {
        [continueWithFacebookButton, continueWithInstagramButton, skipLoginButton].forEach { button in
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

