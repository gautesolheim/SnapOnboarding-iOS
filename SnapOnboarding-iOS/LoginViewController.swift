import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet private var continueWithFacebookButton: UIButton?
    @IBOutlet private var continueWithInstagramButton: UIButton?
    @IBOutlet private var skipLoginButton: UIButton?
    
    @IBOutlet private var continueWithFacebookButtonWidth: NSLayoutConstraint?
    @IBOutlet private var continueWithInstagramButtonWidth: NSLayoutConstraint?
    
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
    private var stringsViewModel: SnapOnboardingViewModel?
    
    func applyStrings(strings: SnapOnboardingViewModel) {
        self.stringsViewModel = strings
    }
    
    // MARK: - UIViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureContinueWithFacebookButton()
        configureContinueWithInstagramButton()
        configureSkipLoginButton()
        alignFacebookAndInstagramButtons()
    }
    
    private func configureContinueWithFacebookButton() {
        continueWithFacebookButton?.setTitle(stringsViewModel?.continueWithFacebook?.uppercaseString, forState: .Normal)
        let intrinsicContentWidth = continueWithFacebookButton?.intrinsicContentSize().width ?? 245
        let rightPadding: CGFloat = 25
        let requiredWidth = intrinsicContentWidth + rightPadding
        continueWithFacebookButtonWidth?.constant = requiredWidth
    }
    
    private func configureContinueWithInstagramButton() {
        continueWithInstagramButton?.setTitle(stringsViewModel?.continueWithInstagram?.uppercaseString, forState: .Normal)
        let intrinsicContentWidth = continueWithInstagramButton?.intrinsicContentSize().width ?? 245
        let rightPadding: CGFloat = 25
        let requiredWidth = intrinsicContentWidth + rightPadding
        continueWithInstagramButtonWidth?.constant = requiredWidth
    }
    
    private func configureSkipLoginButton() {
        skipLoginButton?.setTitle(stringsViewModel?.skipWithoutLogin, forState: .Normal)
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
