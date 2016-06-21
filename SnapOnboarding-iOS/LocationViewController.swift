import UIKit

class LocationViewController: UIViewController {
    
    private var stringsViewModel: SnapOnboardingStringsViewModel?
    
    internal func applyStrings(strings: SnapOnboardingStringsViewModel) {
        self.stringsViewModel = strings
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
