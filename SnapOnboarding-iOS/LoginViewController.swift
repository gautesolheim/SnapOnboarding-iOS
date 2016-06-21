import UIKit

class LoginViewController: UIViewController {
    
    private var stringsViewModel: SnapOnboardingStringsViewModel?
    
    internal func applyStrings(strings: SnapOnboardingStringsViewModel) {
        self.stringsViewModel = strings
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
