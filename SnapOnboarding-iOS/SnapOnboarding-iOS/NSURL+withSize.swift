import UIKit

extension NSURL {

    func withSize(size: CGSize) -> NSURL {

        let scale = UIScreen.mainScreen().scale
        let scaledSize = CGSizeMake(size.width * scale, size.height * scale)

        if ((scaledSize.width ?? 512) != 512 && (scaledSize.height ?? 512) != 512) &&
            (scaledSize.height != 512 && scaledSize.width != 512) {
            guard var absoluteString = self.absoluteString else {
                return NSURL()
            }

            if let squareRange = absoluteString.rangeOfString("=-c") {
                absoluteString = absoluteString.substringToIndex(squareRange.startIndex)
            }

            guard let fetchingUrl = NSURL(string: "\(absoluteString)=s\(Int(max(scaledSize.width, scaledSize.height)))-c") else {
                return NSURL()
            }

            return fetchingUrl
        }

        return self
    }

}
