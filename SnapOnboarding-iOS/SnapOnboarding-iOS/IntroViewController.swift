import UIKit
import SnapFonts_iOS

private enum EmbedSegueIdentifier: String {
    case TagsCollectionViewController = "TagsContainerViewEmbed"
}

class IntroViewController: UIViewController {

    @IBOutlet private(set) var nextButton: UIButton?
    @IBOutlet private(set) var headlineLabel: SnapOnboardingHeadlineLabel?
    @IBOutlet private(set) var sparklingStars: [UIImageView]?
    
    @IBOutlet private var topSpacerToSuperViewHeightRelation: NSLayoutConstraint?
    @IBOutlet private var sparklingViewTopToHeadlineSparklingSpacerBottom: NSLayoutConstraint?
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
        
        setupForScreenSize(SnapOnboardingViewController.screenSize)
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
        
        setupForScreenSize(size)
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
    
    internal func configureNextButton() {
        guard let title = viewModel?.next?.uppercaseString else {
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.18
        
        let attributedText = NSAttributedString(string: title, attributes: [NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : UIColor.whiteColor()])
        nextButton?.setAttributedTitle(attributedText, forState: .Normal)
    }
    
    internal func configureHeadlineLabel() {
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

// MARK: - HasNextButtonAndHeadlineLabel

extension IntroViewController: HasNextButtonAndHeadlineLabel {}

// MARK: - ScreenSizesProtocol

extension IntroViewController {
    
    func setupFor3_5InchPortrait() {
        configureNextButtonAndHeadlineLabelFor3_5Inch()
        
        tagsContainerViewHeight?.constant = 30
        sparklingViewToSuperViewHeightRelation?.constant = -10
    }
    
    func setupFor4_0InchPortrait() {
        configureNextButtonAndHeadlineLabelFor4_0Inch()
        
        sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = -10
        sparklingViewToSuperViewHeightRelation?.constant = 10
        phoneViewToSparklingViewHeightRelation?.constant = -5
    }
    
    func setupFor5_5InchPortrait() {
        configureNextButtonAndHeadlineLabelFor5_5Inch()
    }
    
    func setupForIpadPortrait(size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpad()
        
        phoneViewTopToSparklingViewTop?.constant = 40
        phoneViewToSparklingViewHeightRelation?.constant = 20
        tagsContainerViewHeight?.constant = 80
        
        if size.width <= 320 {
            sparklingViewToSuperViewHeightRelation?.constant = -120
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 20
        } else {
            sparklingViewToSuperViewHeightRelation?.constant = -20
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 30
        }
    }
    
    func setupForIpadLandscape(size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpad()
        
        phoneViewTopToSparklingViewTop?.constant = 20
        tagsContainerViewHeight?.constant = 80
        
        if size.width <= 320 {
            sparklingViewToSuperViewHeightRelation?.constant = -110
            phoneViewToSparklingViewHeightRelation?.constant = -20
        } else {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 10
            sparklingViewToSuperViewHeightRelation?.constant = 20
            phoneViewToSparklingViewHeightRelation?.constant = 20
        }
    }
    
    func setupForIpadProPortrait(size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpadPro()
        
        phoneViewTopToSparklingViewTop?.constant = 50
        tagsContainerViewHeight?.constant = 90
        
        if size.width <= 375 {
            topSpacerToSuperViewHeightRelation?.constant = 20
            sparklingViewToSuperViewHeightRelation?.constant = -260
            phoneViewToSparklingViewHeightRelation?.constant = -20
        } else {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 40
            sparklingViewToSuperViewHeightRelation?.constant = -100
            phoneViewToSparklingViewHeightRelation?.constant = 30
        }
    }
    
    func setupForIpadProLandscape(size: CGSize) {
        configureNextButtonAndHeadlineLabelForIpadPro()
        
        phoneViewTopToSparklingViewTop?.constant = 30
        tagsContainerViewHeight?.constant = 90
        
        if size.width <= 375 {
            headlineLabel?.font = SnapFonts.gothamRoundedBookOfSize(30)
            topSpacerToSuperViewHeightRelation?.constant = 10
            sparklingViewToSuperViewHeightRelation?.constant = -160
            phoneViewToSparklingViewHeightRelation?.constant = -20
        } else {
            sparklingViewTopToHeadlineSparklingSpacerBottom?.constant = 10
            sparklingViewToSuperViewHeightRelation?.constant = -50
            phoneViewToSparklingViewHeightRelation?.constant = 30
        }
    }
    
}
