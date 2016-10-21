import Foundation
import UIKit

public extension URL {
    
    public func withSize(_ size: CGSize) -> URL {
        
        let scale = UIScreen.main.scale
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        if (scaledSize.width != 512 && scaledSize.height != 512) &&
            (scaledSize.height != 512 && scaledSize.width != 512) {
            var absoluteString = self.absoluteString
            
            if let squareRange = absoluteString.range(of: "=-c") {
                absoluteString = absoluteString.substring(to: squareRange.lowerBound)
            }
            
            guard let fetchingUrl = URL(string: "\(absoluteString)=s\(Int(max(scaledSize.width, scaledSize.height)))-c") else {
                return URL(string: "https://snapsale.com")!
            }
            
            return fetchingUrl
        }
        
        return self
    }
    
}
