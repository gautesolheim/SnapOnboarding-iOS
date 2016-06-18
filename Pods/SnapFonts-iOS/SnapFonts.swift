import UIKit

public class SnapFonts: NSObject {
    
    private static func loadFontWithFileName(fileName: String) {
        let bundleURL = NSBundle(forClass: self.classForCoder()).URLForResource("Fonts", withExtension: "bundle")!
        let bundle = NSBundle(URL: bundleURL)!
        let fontURL = bundle.URLForResource(fileName, withExtension: "otf")!
        let fontData = NSData(contentsOfURL: fontURL)
        
        let provider = CGDataProviderCreateWithCFData(fontData)
        let font = CGFontCreateWithDataProvider(provider)!
        
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
        
        if error != nil {
            print(error.debugDescription)
        }
    }
    
    private static func loadFontWithFileNameOnce(fileName: String, inout token: dispatch_once_t) {
        dispatch_once(&token) {
            loadFontWithFileName(fileName)
        }
    }
    
    public static func gothamRoundedBoldOfSize(size: CGFloat) -> UIFont? {
        struct Token { static var token: dispatch_once_t = 0 }
        loadFontWithFileNameOnce("GothamRnd-Bold", token: &Token.token)
        
        return UIFont(name: "GothamRounded-Bold", size: size)
    }
    
    public static func gothamRoundedBoldItalicOfSize(size: CGFloat) -> UIFont? {
        struct Token { static var token: dispatch_once_t = 0 }
        loadFontWithFileNameOnce("GothamRnd-BoldIta", token: &Token.token)
        
        return UIFont(name: "GothamRounded-BoldItalic", size: size)
    }
    
    public static func gothamRoundedBookOfSize(size: CGFloat) -> UIFont? {
        struct Token { static var token: dispatch_once_t = 0 }
        loadFontWithFileNameOnce("GothamRnd-Book", token: &Token.token)
        
        return UIFont(name: "GothamRounded-Book", size: size)
    }
    
    public static func gothamRoundedBookItalicOfSize(size: CGFloat) -> UIFont? {
        struct Token { static var token: dispatch_once_t = 0 }
        loadFontWithFileNameOnce("GothamRnd-BookIta", token: &Token.token)
        
        return UIFont(name: "GothamRounded-BookItalic", size: size)
    }
    
    public static func gothamRoundedLightOfSize(size: CGFloat) -> UIFont? {
        struct Token { static var token: dispatch_once_t = 0 }
        loadFontWithFileNameOnce("GothamRnd-Light", token: &Token.token)
        
        return UIFont(name: "GothamRounded-Light", size: size)
    }
    
    public static func gothamRoundedLightItalicOfSize(size: CGFloat) -> UIFont? {
        struct Token { static var token: dispatch_once_t = 0 }
        loadFontWithFileNameOnce("GothamRnd-LightIta", token: &Token.token)
        
        return UIFont(name: "GothamRounded-LightItalic", size: size)
    }
    
    public static func gothamRoundedMediumOfSize(size: CGFloat) -> UIFont? {
        struct Token { static var token: dispatch_once_t = 0 }
        loadFontWithFileNameOnce("GothamRnd-Medium", token: &Token.token)
        
        return UIFont(name: "GothamRounded-Medium", size: size)
    }
    
    public static func gothamRoundedMediumItalicOfSize(size: CGFloat) -> UIFont? {
        struct Token { static var token: dispatch_once_t = 0 }
        loadFontWithFileNameOnce("GothamRnd-MedIta", token: &Token.token)
        
        return UIFont(name: "GothamRounded-MediumItalic", size: size)
    }
    
}