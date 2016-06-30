import UIKit
import SnapFonts_iOS

protocol IntroViewControllerProtocol: class {
//    var delegate: IntroViewControllerDelegate? { get set }
//    func configureForViewModel(viewModel: IntroViewModel)
}

private enum EmbedSegueIdentifier: String {
    case TagsCollectionViewController = "tagsContainerViewEmbed"
}

class IntroViewController: UIViewController {

    @IBOutlet private var nextButton: UIButton?
    @IBOutlet private var headlineLabel: SnapOnboardingHeadlineLabel?
    
    
    
    @IBOutlet private var tagsContainerViewHeight: NSLayoutConstraint?
    @IBOutlet private var sparklingViewToSuperViewHeightRelation: NSLayoutConstraint?
    
    var delegate: IntroViewControllerDelegate?
    private var viewModel: SnapOnboardingViewModel.IntroViewModel?
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        delegate?.introNextButtonTapped()
    }
    
    func configureForViewModel(viewModel: SnapOnboardingViewModel.IntroViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: UIViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupForScreenSize(UIScreen.mainScreen().bounds)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNextButton()
        configureHeadlineLabel()
        headlineLabel?.layoutIfNeeded()
    }
    
    private func configureNextButton() {
        let title = viewModel?.next?.uppercaseString
        nextButton?.setTitle(title, forState: .Normal)
    }
    
    private func configureHeadlineLabel() {
        headlineLabel?.updateText(viewModel?.introHeadline)
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

}

// MARK: - IntroViewControllerProtocol

extension IntroViewController: IntroViewControllerProtocol {
    
}

// MARK: - ScreenSizesProtocol

extension IntroViewController {
    
    func setupFor3_5Inch() {
        nextButton?.contentEdgeInsets.top -= 5
        
        headlineLabel?.font = SnapFonts.gothamRoundedBookOfSize(17)
        headlineLabel?.lineSpacin = 4
        
        tagsContainerViewHeight?.constant = 30
        sparklingViewToSuperViewHeightRelation?.constant -= 10
    }
    
    func setupFor4_0Inch() {
        headlineLabel?.font = SnapFonts.gothamRoundedBookOfSize(19)
        headlineLabel?.lineSpacin = 5
    }
    
}