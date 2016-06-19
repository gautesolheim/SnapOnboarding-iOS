import UIKit

class IntroViewController: UIViewController {

    @IBOutlet var infoLabel: UILabel?
    
    var delegate: IntroViewControllerDelegate?
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        delegate?.nextButtonTapped()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInfoLabel()
    }
    
    private func configureInfoLabel() {
        // TODO: Line height, NSLocalizedString
    }

}
