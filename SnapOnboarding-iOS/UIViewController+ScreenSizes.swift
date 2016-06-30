import UIKit

@objc public protocol ScreenSizesProtocol: class {
    optional func setupFor3_5Inch()
    optional func setupFor4_0Inch()
    optional func setupFor4_7Inch()
    optional func setupFor5_5Inch()
}

extension UIViewController: ScreenSizesProtocol {
    
    // @param: UIScreen.mainScreen().bounds (Swift 3: UIScreen.main().bounds
    public func setupForScreenSize(size: CGRect) {
        let mySelf = self as ScreenSizesProtocol
        let height = size.height
        
        switch(size.width) {
        // iPhone 4, 4s
        case 320 where height == 480:
            mySelf.setupFor3_5Inch?()
        // iPhone 5, 5s, SE, iPod touch 5g
        case 320:
            mySelf.setupFor4_0Inch?()
        // iPhone 6, 6s
        case 375:
            mySelf.setupFor4_7Inch?()
        // iPhone 6+, 6s+
        case 414:
            mySelf.setupFor5_5Inch?()
        default: break
        }
    }
    
}