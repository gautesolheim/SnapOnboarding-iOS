import UIKit

class LoginViewController: UIViewController {
    
    var delegate: LoginViewControllerDelegate?
    private var stringsViewModel: SnapOnboardingStringsViewModel?
    
    func applyStrings(strings: SnapOnboardingStringsViewModel) {
        self.stringsViewModel = strings
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
