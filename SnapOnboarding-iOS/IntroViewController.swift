import UIKit
import SnapFonts_iOS

private enum EmbedSegueIdentifier: String {
    case TagsCollectionViewController = "tagsContainerViewEmbed"
}

class IntroViewController: UIViewController {

    @IBOutlet private var nextButton: UIButton?
    @IBOutlet private var headlineLabel: SnapOnboardingHeadlineLabel?
    @IBOutlet private(set) var sparklingStars: [UIImageView]?
    
    @IBOutlet private var star6CenterYToSparklingViewCenterYRelation: NSLayoutConstraint?
    @IBOutlet private var star7CenterYToSparklingViewCenterYRelation: NSLayoutConstraint?
    
    @IBOutlet private var headlineSparklingSpacerHeightToSuperViewRelation: NSLayoutConstraint?
    @IBOutlet private var tagsContainerViewHeight: NSLayoutConstraint?
    @IBOutlet private var tagsContainerViewTopToPhoneViewBottom: NSLayoutConstraint?
    @IBOutlet private var phoneViewTopToSparklingViewTop: NSLayoutConstraint?
    @IBOutlet private var phoneViewToSparklingViewHeightRelation: NSLayoutConstraint?
    @IBOutlet private var sparklingViewToSuperViewHeightRelation: NSLayoutConstraint?
    
    var delegate: IntroViewControllerDelegate?
    private var viewModel: SnapOnboardingViewModel.IntroViewModel?
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        delegate?.introNextButtonTapped()
    }
    
    // MARK: UIViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(viewModel != nil)
        
        setupForScreenSize(UIScreen.mainScreen().bounds)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNextButton()
        configureHeadlineLabel()
        
        let duration: NSTimeInterval = 2
        animateSparklingStarsWithCycleDuration(duration)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        print("will-transition-to-size")
        setupForScreenSize(UIScreen.mainScreen().bounds)
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
    
    func setupFor3_5InchPortrait() {
        nextButton?.contentEdgeInsets.top = 10
        
        headlineLabel?.font = SnapFonts.gothamRoundedBookOfSize(17)
        headlineLabel?.lineSpacin = 4
        
        tagsContainerViewHeight?.constant = 30
        sparklingViewToSuperViewHeightRelation?.constant = -10
    }
    
    func setupFor4_0InchPortrait() {
        headlineLabel?.font = SnapFonts.gothamRoundedBookOfSize(18)
        headlineLabel?.lineSpacin = 5
    }
    
    func setupForIpadPortrait() {
        nextButton?.titleLabel?.font = SnapFonts.gothamRoundedMediumOfSize(16)
        nextButton?.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 23)

        headlineLabel?.font = SnapFonts.gothamRoundedBookOfSize(26)
        headlineSparklingSpacerHeightToSuperViewRelation?.constant = 30
        tagsContainerViewHeight?.constant = 80
        tagsContainerViewTopToPhoneViewBottom?.active = false
        
        star6CenterYToSparklingViewCenterYRelation?.constant = 20
        star7CenterYToSparklingViewCenterYRelation?.constant = 25
        
        sparklingViewToSuperViewHeightRelation?.constant = -20
        phoneViewToSparklingViewHeightRelation?.constant = 20
        phoneViewTopToSparklingViewTop?.constant = 40
    }
    
    func setupForIpadLandscape() {
        setupForIpadPortrait()
        phoneViewTopToSparklingViewTop?.constant = 20
        
        if view.frame.width == UIScreen.mainScreen().bounds.width {
            sparklingViewToSuperViewHeightRelation?.constant = 20
        } else {
            star6CenterYToSparklingViewCenterYRelation?.constant = 10
            phoneViewToSparklingViewHeightRelation?.constant = 10
        }
    }
    
}
