import UIKit

@objc public protocol ScreenSizesProtocol: class {
    optional func setupFor3_5InchPortrait()
    optional func setupFor4_0InchPortrait()
    optional func setupFor4_7InchPortrait()
    optional func setupFor5_5InchPortrait()
    optional func setupForIpadPortrait()
    optional func setupForIpadProPortrait()
    
    optional func setupForIpadLandscape()
    optional func setupForIpadProLandscape()
}

extension UIViewController: ScreenSizesProtocol {
    
    // @param: UIScreen.mainScreen().bounds (Swift 3: UIScreen.main().bounds)
    public func setupForScreenSize(size: CGRect) {
        print("screen-size: \(size)")
        let mySelf = self as ScreenSizesProtocol
        let height = size.height
        
        switch(size.width) {
        case 320 where height == 480:
            // iPhone 4, 4s PORTRAIT
            mySelf.setupFor3_5InchPortrait?()
        case 320 where height == 568:
            // iPhone 5, 5s, SE, iPod touch 5g PORTRAIT
            mySelf.setupFor4_0InchPortrait?()
        case 375 where height == 667:
            // iPhone 6, 6s PORTRAIT
            mySelf.setupFor4_7InchPortrait?()
        case 414 where height == 736:
            // iPhone 6+, 6s+ PORTRAIT
            mySelf.setupFor5_5InchPortrait?()
        case 768 where height == 1024:
            // iPad Mini, iPad Air PORTRAIT
            mySelf.setupForIpadPortrait?()
        case 1024 where height == 1366:
            // iPad Pro 12,9" PORTRAIT
            mySelf.setupForIpadProPortrait?()
            
        case 1024 where height == 768:
            // iPad Mini, iPad Air LANDSCAPE
            mySelf.setupForIpadLandscape?()
        case 1366 where height == 1024:
            // iPad Pro 12,9" LANDSCAPE
            mySelf.setupForIpadProLandscape?()
            
        default: break
        }
    }
    
}
