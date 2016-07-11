import UIKit

@objc public protocol ScreenSizesProtocol: class {
    optional func setupFor3_5Inch()
    optional func setupFor4_0Inch()
    optional func setupFor4_7Inch()
    optional func setupFor5_5Inch()
    optional func setupForIpad()
    optional func setupForIpadPro()
}

extension UIViewController: ScreenSizesProtocol {
    
    // @param: UIScreen.mainScreen().bounds (Swift 3: UIScreen.main().bounds)
    public func setupForScreenSize(size: CGRect) {
        let mySelf = self as ScreenSizesProtocol
        let height = size.height
        
        switch(size.width) {
        case 320 where height == 480:
            // iPhone 4, 4s PORTRAIT
            mySelf.setupFor3_5Inch?()
        case 320:
            // iPhone 5, 5s, SE, iPod touch 5g PORTRAIT
            mySelf.setupFor4_0Inch?()
        case 375:
            // iPhone 6, 6s PORTRAIT
            mySelf.setupFor4_7Inch?()
        case 414:
            // iPhone 6+, 6s+ PORTRAIT
            mySelf.setupFor5_5Inch?()
        case 768:
            // iPad Mini, iPad Air
            mySelf.setupForIpad?()
        case 1024:
            // iPad Pro 12,9"
            mySelf.setupForIpadPro?()
        default: break
        }
    }
    
}
