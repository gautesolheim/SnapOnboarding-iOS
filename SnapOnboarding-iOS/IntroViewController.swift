import UIKit
import SnapFonts_iOS

private enum EmbedSegueIdentifier: String {
    case TagsCollectionViewController = "tagsContainerViewEmbed"
}

class IntroViewController: UIViewController {

    @IBOutlet private var nextButton: UIButton?
    @IBOutlet private var headlineLabel: SnapOnboardingHeadlineLabel?
    @IBOutlet private(set) var sparklingStars: [UIImageView]?
    
    @IBOutlet private var headlineSparklingSpacerHeightToSuperViewRelation: NSLayoutConstraint?
    @IBOutlet private var tagsContainerViewHeight: NSLayoutConstraint?
    @IBOutlet private var tagsContainerViewTopToPhoneViewBottom: NSLayoutConstraint?
    @IBOutlet private var phoneViewTopToSparklingViewTop: NSLayoutConstraint?
    @IBOutlet private var phoneViewToSparklingViewHeightRelation: NSLayoutConstraint?
    @IBOutlet private var phoneViewCenterYInContainer: NSLayoutConstraint?
    @IBOutlet private var sparklingViewToSuperViewHeightRelation: NSLayoutConstraint?
    
    var delegate: IntroViewControllerDelegate?
    private var viewModel: SnapOnboardingViewModel.IntroViewModel?
    
    lazy var screenSize: CGRect = UIScreen.mainScreen().bounds
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        delegate?.introNextButtonTapped()
    }
    
    // MARK: UIViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(viewModel != nil)
        
        setupForScreenSize(screenSize)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNextButton()
        configureHeadlineLabel()
        
        let duration: NSTimeInterval = 2
        animateSparklingStarsWithCycleDuration(duration)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier, viewModel = viewModel else {
            return
        }
        
        switch identifier {
        case EmbedSegueIdentifier.TagsCollectionViewController.rawValue:
            let destinationViewController = segue.destinationViewController as? TagsCollectionViewController
            let viewModel = TagsViewModel(data: viewModel.tags)
            destinationViewController?.configureForViewModel(viewModel)
        default: break
        }
    }
    
    // MARK: UIView configuration
    
    private func configureNextButton() {
        let title = viewModel?.next?.uppercaseString
        nextButton?.setTitle(title, forState: .Normal)
    }
    
    private func configureHeadlineLabel() {
        headlineLabel?.updateText(viewModel?.introHeadline)
    }

}

// MARK: - IntroViewControllerProtocol

extension IntroViewController: IntroViewControllerProtocol {
    
    func configureForViewModel(viewModel: SnapOnboardingViewModel.IntroViewModel) {
        self.viewModel = viewModel
    }
    
}

// MARK: - HasSparklingStars

extension IntroViewController: HasSparklingStars {}

// MARK: - ScreenSizesProtocol

extension IntroViewController {
    
    func setupFor3_5Inch() {
        nextButton?.contentEdgeInsets.top = 10
        
        headlineLabel?.font = SnapFonts.gothamRoundedBookOfSize(17)
        headlineLabel?.lineSpacin = 4
        
        tagsContainerViewHeight?.constant = 30
        sparklingViewToSuperViewHeightRelation?.constant = -10
    }
    
    func setupFor4_0Inch() {
        headlineLabel?.font = SnapFonts.gothamRoundedBookOfSize(18)
        headlineLabel?.lineSpacin = 5
    }
    
    func setupForIpad() {
        nextButton?.titleLabel?.font = SnapFonts.gothamRoundedMediumOfSize(16)
        nextButton?.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 23)

        headlineLabel?.font = SnapFonts.gothamRoundedBookOfSize(26)
        headlineSparklingSpacerHeightToSuperViewRelation?.constant = 30
        tagsContainerViewHeight?.constant = 80
        tagsContainerViewTopToPhoneViewBottom?.active = false
        //
        sparklingViewToSuperViewHeightRelation?.constant = -20
        phoneViewToSparklingViewHeightRelation?.constant = 20
        phoneViewTopToSparklingViewTop?.constant = 40
        //
        
//        phoneViewCenterYInContainer?.constant = -100
//        phoneViewCenterYInContainer?.active = true
    }
    
}
