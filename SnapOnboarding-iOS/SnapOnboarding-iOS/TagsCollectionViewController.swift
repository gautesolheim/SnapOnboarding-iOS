import SnapTagsView
import SnapFonts_iOS

struct TagsViewModel {
    var data: [SnapTagRepresentation]?
}

class TagsCollectionViewController: SnapTagsCollectionViewController {
    
    private var fontSize: CGFloat = 13
    private var spacing: CGFloat = 10
    private var insets = UIEdgeInsets(top: 8.5, left: 9.5, bottom: 8.5, right: 9.5)
    
    func configureForViewModel(viewModel: TagsViewModel) {
        data = viewModel.data ?? [SnapTagRepresentation]()
    }
    
    override func viewDidLoad() {
        setupForScreenSize(SnapOnboardingViewController.screenSize)
        configuration = createConfiguration()
        buttonConfiguration = createButtonConfiguration()
        
        super.viewDidLoad()
    }
    
    func createConfiguration() -> SnapTagsViewConfiguration {
        var config = SnapTagsViewConfiguration()
        config.spacing = spacing
        config.horizontalMargin = 0
        config.verticalMargin = 0
        config.contentHeight = fontSize
        config.alignment = .Center
        
        return config
    }
    
    func createButtonConfiguration() -> SnapTagButtonConfiguration {
        var config = SnapTagButtonConfiguration()
        config.font = SnapFonts.gothamRoundedMediumOfSize(fontSize)
        config.margin = UIEdgeInsetsZero
        config.labelInset = insets
        
        var onState = ButtonStateConfiguration()
        onState.backgroundColor = UIColor.whiteColor()
        onState.textColor = UIColor.blackColor()
        onState.cornerRadius = 4
        
        var offState = onState
        offState.buttonTransform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(M_PI * 45 / 180.0))
        offState.backgroundColor = UIColor.whiteColor()
        offState.textColor = UIColor.roseColor()
        offState.borderColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
        offState.borderWidth = 0
        
        var highlightedOnState = onState
        highlightedOnState.backgroundColor = UIColor(red: 229/255.0, green: 0/255.0, blue: 79/255.0, alpha: 1)
        
        let highlightedOffState = highlightedOnState
        
        config.onState = onState
        config.offState = offState
        config.highlightedWhileOnState = highlightedOnState
        config.highlightedWhileOffState = highlightedOffState
        
        return config
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        
        // collectionView is internal in SnapTagsView
        collectionView.clipsToBounds = false
        
        cell.layer.masksToBounds = false
        cell.layer.shadowOpacity = 0.15
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOffset = CGSize(width: 0, height:1)
        cell.layer.shadowRadius = 1
        
        return cell
    }
    
}

// MARK: ScreenSizesProtocol

extension TagsCollectionViewController {
    
    func setupForIpadPortrait(size: CGSize) {
        setupForIpad()
    }
    
    func setupForIpadLandscape(size: CGSize) {
        setupForIpad()
    }
    
    func setupForIpadProPortrait(size: CGSize) {
        setupForIpadPro()
    }
    
    func setupForIpadProLandscape(size: CGSize) {
        setupForIpadPro()
    }
    
    // MARK: Helpers
    
    private func setupForIpad() {
        fontSize = 15
        spacing = 12
        insets = UIEdgeInsets(top: 9.5, left: 10.5, bottom: 9.5, right: 10.5)
    }
    
    private func setupForIpadPro() {
        fontSize = 17
        spacing = 14
        insets = UIEdgeInsets(top: 10.5, left: 11.5, bottom: 10.5, right: 11.5)
    }
    
}
