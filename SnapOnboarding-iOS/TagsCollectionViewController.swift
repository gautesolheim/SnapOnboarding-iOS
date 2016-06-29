import Foundation
import SnapTagsView
import SnapFonts_iOS

struct TagsViewModel {
    var data: [SnapTagRepresentation]?
}

class TagsCollectionViewController: SnapTagsCollectionViewController {
    
    func configureForViewModel(viewModel: TagsViewModel) {
        data = viewModel.data ?? [SnapTagRepresentation]()
        
        configuration = createConfiguration()
        buttonConfiguration = createButtonConfiguration()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollEnabled = false
    }
    
    func createConfiguration() -> SnapTagsViewConfiguration {
        var config = SnapTagsViewConfiguration()
        config.spacing = 10.0
        config.horizontalMargin = 0
        config.verticalMargin = 0
        config.contentHeight = 13.0
        config.alignment = .Center
        
        return config
    }
    
    func createButtonConfiguration() -> SnapTagButtonConfiguration {
        var config = SnapTagButtonConfiguration()
        config.font = SnapFonts.gothamRoundedMediumOfSize(13)
        config.canBeTurnedOnAndOff = true
        config.margin = UIEdgeInsetsZero
        config.labelInset = UIEdgeInsets(top: 8.5, left: 9.5, bottom: 8.5, right: 9.5)
        
        var onState = ButtonStateConfiguration()
        onState.buttonImage = UIImage.SnapTagsViewAssets.YellowCloseButton.image
        onState.backgroundColor = UIColor.whiteColor()
        onState.textColor = UIColor.blackColor()
        onState.hasButton = false
        onState.cornerRadius = 4
        
        var offState = onState
        offState.buttonImage = UIImage.SnapTagsViewAssets.RedCloseButton.image
        offState.buttonTransform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(M_PI*45.0/180.0))
        offState.backgroundColor = UIColor.whiteColor()
        offState.textColor = UIColor.roseColor()
        offState.borderColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        offState.borderWidth = 0
        
        var highlightedOnState = onState
        highlightedOnState.backgroundColor = UIColor(red: 229.0/255.0, green: 0.0, blue: 79.0/255.0, alpha: 1.0)
        
        let highlightedOffState = highlightedOnState
        
        config.onState = onState
        config.offState = offState
        config.highlightedWhileOnState = highlightedOnState
        config.highlightedWhileOffState = highlightedOffState
        
        return config
    }
    
}