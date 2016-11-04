import UIKit

@objc public protocol ScreenSizesProtocol: class {
    @objc optional func setupFor3_5InchPortrait()
    @objc optional func setupFor4_0InchPortrait()
    @objc optional func setupFor4_7InchPortrait()
    @objc optional func setupFor5_5InchPortrait()
    @objc optional func setupForIpadPortrait(_ size: CGSize)
    @objc optional func setupForIpadProPortrait(_ size: CGSize)
    
    @objc optional func setupForIpadLandscape(_ size: CGSize)
    @objc optional func setupForIpadProLandscape(_ size: CGSize)
}

extension UIViewController: ScreenSizesProtocol {
    
    class var screenSize: CGSize {
        // Swift 3: UIScreen.main().bounds.size
        return UIScreen.main.bounds.size
    }
    
    // @param: screenSize
    public func setupForScreenSize(_ size: CGSize) {
        let mySelf = self as ScreenSizesProtocol
        let width = size.width
        
        switch size.height {
        case 480 where width == 320:
            // iPhone 4, 4s PORTRAIT
            mySelf.setupFor3_5InchPortrait?()
        case 568 where width == 320:
            // iPhone 5, 5s, SE, iPod touch 5g PORTRAIT
            mySelf.setupFor4_0InchPortrait?()
        case 667 where width == 375:
            // iPhone 6, 6s PORTRAIT
            mySelf.setupFor4_7InchPortrait?()
        case 736 where width == 414:
            // iPhone 6+, 6s+ PORTRAIT
            mySelf.setupFor5_5InchPortrait?()
        case 1024 where width == 768 || width == 438 || width == 320:
            // iPad Mini, iPad Air PORTRAIT
            mySelf.setupForIpadPortrait?(size)
        case 1366:
            // iPad Pro 12,9" PORTRAIT
            mySelf.setupForIpadProPortrait?(size)
        
        case 768:
            // iPad Mini, iPad Air LANDSCAPE
            mySelf.setupForIpadLandscape?(size)
        case 1024:
            // iPad Pro 12,9" LANDSCAPE
            mySelf.setupForIpadProLandscape?(size)
        default: break
        }
        
    }
    
}
