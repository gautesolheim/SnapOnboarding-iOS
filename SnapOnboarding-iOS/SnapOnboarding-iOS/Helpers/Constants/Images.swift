// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS)
  import UIKit.UIImage
  typealias Image = UIImage
#elseif os(OSX)
  import AppKit.NSImage
  typealias Image = NSImage
#endif

private class ClassInSameBundleAsAssets: NSObject {}

enum Asset: String {
  case Iphone = "iphone"
  case Veske = "veske"
  case Link_Skip = "link skip"
  case Btn_Location_Clean = "btn location clean"
  case Btn_Location = "btn location"
  case Icon_m_spinner_black = "icon_m_spinner_black"
  case Icon_tumbleweed = "icon_tumbleweed"
  case Illustration_neighborhood = "illustration_neighborhood"
  case Neighborhood_Photo0 = "neighborhood-photo0"
  case Neighborhood_Photo1 = "neighborhood-photo1"
  case Neighborhood_Photo2 = "neighborhood-photo2"
  case Neighborhood_Photo3 = "neighborhood-photo3"
  case Neighborhood_Photo4 = "neighborhood-photo4"
  case Neighborhood_Photo5 = "neighborhood-photo5"
  case Neighborhood_Photo6 = "neighborhood-photo6"
  case Neighborhood_Photo7 = "neighborhood-photo7"
  case Btn_Login_Facebook = "btn login facebook"
  case Btn_Login_Instagram = "btn login instagram"
  case Items_Pattern = "items-pattern"
  case Logo_Snapsale = "logo snapsale"
  case Star = "star"
  case Tags_background = "tags_background"

  var image: Image {
    return Image(asset: self)
  }
}

extension Image {
  convenience init!(asset: Asset) {
    let bundle = NSBundle(forClass: ClassInSameBundleAsAssets.self)
    self.init(named: asset.rawValue, inBundle: bundle, compatibleWithTraitCollection: nil)
  }
}

