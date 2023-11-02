// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal static let video = ImageAsset(name: "video")
  internal static let _0E0D12 = ColorAsset(name: "0E0D12")
  internal static let _177Cef = ColorAsset(name: "177CEF")
  internal static let _757580 = ColorAsset(name: "757580")
  internal static let _939597 = ColorAsset(name: "939597")
  internal static let c1C1C1 = ColorAsset(name: "C1C1C1")
  internal static let eeeeee = ColorAsset(name: "EEEEEE")
  internal static let f8F8F8 = ColorAsset(name: "F8F8F8")
  internal static let ff4039 = ColorAsset(name: "FF4039")
  internal static let bgComment = ColorAsset(name: "bgComment")
  internal static let bgFaceCam = ColorAsset(name: "bgFaceCam")
  internal static let bgLive = ColorAsset(name: "bgLive")
  internal static let bgScreen = ColorAsset(name: "bgScreen")
  internal static let bgVideoEditor = ColorAsset(name: "bgVideoEditor")
  internal static let icArrowLeft = ImageAsset(name: "ic_arrow_left")
  internal static let icFaceCam = ImageAsset(name: "ic_face_cam")
  internal static let icFilterVideo = ImageAsset(name: "ic_filter_video")
  internal static let icRotate = ImageAsset(name: "ic_rotate")
  internal static let icTrash = ImageAsset(name: "ic_trash")
  internal static let icVideoSize = ImageAsset(name: "ic_video_size")
  internal static let component439 = ImageAsset(name: "Component 43 – 9")
  internal static let component5118 = ImageAsset(name: "Component 51 – 18")
  internal static let component5356 = ImageAsset(name: "Component 53 – 56")
  internal static let component5357 = ImageAsset(name: "Component 53 – 57")
  internal static let component631 = ImageAsset(name: "Component 63 – 1")
  internal static let component638 = ImageAsset(name: "Component 63 – 8")
  internal static let component641 = ImageAsset(name: "Component 64 – 1")
  internal static let component648 = ImageAsset(name: "Component 64 – 8")
  internal static let iconCIColorClamp = ImageAsset(name: "icon_ CIColorClamp")
  internal static let iconCIColorControls = ImageAsset(name: "icon_CIColorControls")
  internal static let iconCIColorMatrix = ImageAsset(name: "icon_CIColorMatrix")
  internal static let iconCIExposureAdjust = ImageAsset(name: "icon_CIExposureAdjust")
  internal static let group24385 = ImageAsset(name: "Group 24385")
  internal static let group24386 = ImageAsset(name: "Group 24386")
  internal static let group24387 = ImageAsset(name: "Group 24387")
  internal static let group24388 = ImageAsset(name: "Group 24388")
  internal static let group24389 = ImageAsset(name: "Group 24389")
  internal static let group24390 = ImageAsset(name: "Group 24390")
  internal static let group24391 = ImageAsset(name: "Group 24391")
  internal static let group24393 = ImageAsset(name: "Group 24393")
  internal static let group24400 = ImageAsset(name: "Group 24400")
  internal static let group24401 = ImageAsset(name: "Group 24401")
  internal static let group24403 = ImageAsset(name: "Group 24403")
  internal static let group24404 = ImageAsset(name: "Group 24404")
  internal static let group24405 = ImageAsset(name: "Group 24405")
  internal static let group24409 = ImageAsset(name: "Group 24409")
  internal static let maskGroup398 = ImageAsset(name: "Mask Group 398")
  internal static let icContactMore = ImageAsset(name: "ic_contact_more")
  internal static let icPremiumMore = ImageAsset(name: "ic_premium_more")
  internal static let icPrivacyMore = ImageAsset(name: "ic_privacy_more")
  internal static let icRateMore = ImageAsset(name: "ic_rate_more")
  internal static let icShareMore = ImageAsset(name: "ic_share_more")
  internal static let icTermsMore = ImageAsset(name: "ic_terms_more")
  internal static let icFaceCamHome = ImageAsset(name: "ic_FaceCamHome")
  internal static let icScreenRecorder = ImageAsset(name: "ic_ScreenRecorder")
  internal static let icVideoEditorHome = ImageAsset(name: "ic_VideoEditor_home")
  internal static let icCommentary = ImageAsset(name: "ic_commentary")
  internal static let icHomeCamera = ImageAsset(name: "ic_home_camera")
  internal static let icLiveStream = ImageAsset(name: "ic_liveStream")
  internal static let icShare = ImageAsset(name: "ic_share")
  internal static let iconHome = ImageAsset(name: "icon_home")
  internal static let iconMore = ImageAsset(name: "icon_more")
  internal static let iconVideo = ImageAsset(name: "icon_video")
  internal static let icCanvasEditor = ImageAsset(name: "ic_canvas_editor")
  internal static let icRotateEditor = ImageAsset(name: "ic_rotate_editor")
  internal static let icSpeedEditor = ImageAsset(name: "ic_speed_editor")
  internal static let icTrimEditor = ImageAsset(name: "ic_trim_editor")
  internal static let icVideoEditor = ImageAsset(name: "ic_video_editor")
  internal static let icConfigScreen = ImageAsset(name: "ic_config_screen")
  internal static let icDone = ImageAsset(name: "ic_done")
  internal static let icFilterEditor = ImageAsset(name: "ic_filter_editor")
  internal static let icRecordFacecam = ImageAsset(name: "ic_record_facecam")
  internal static let icShareVideo = ImageAsset(name: "ic_share_video")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = Color(asset: self)

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
