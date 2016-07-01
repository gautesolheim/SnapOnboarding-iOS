import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet private var continueWithFacebookButton: UIButton?
    @IBOutlet private var continueWithInstagramButton: UIButton?
    @IBOutlet private var skipLoginButton: UIButton?
    
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
    
    func configureForViewModel(viewModel: SnapOnboardingViewModel.LoginViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: UIViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupForScreenSize(UIScreen.mainScreen().bounds)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureContinueWithFacebookButton()
        configureContinueWithInstagramButton()
        configureSkipLoginButton()
        alignFacebookAndInstagramButtons()
    }
    
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

// MARK: - ScreenSizesProtocol

extension LoginViewController {
    
    func setupFor3_5Inch() {
        topSpacerHeight?.constant -= 22
        
        skipLoginButtonBottomToSuperViewBottom?.constant -= 17
    }
    
    func setupFor4_0Inch() {
        topSpacerHeight?.constant -= 12
    }
    
}

