import UIKit
import LinkPresentation

/// Supplies a shared image together with rich share-sheet metadata (title + app icon),
/// so the share sheet header shows the app icon instead of a blank preview.
final class ShareImageSource: NSObject, UIActivityItemSource {
    private let image: UIImage
    private let title: String

    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }

    func activityViewControllerPlaceholderItem(_ controller: UIActivityViewController) -> Any {
        image
    }

    func activityViewController(_ controller: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        image
    }

    func activityViewControllerLinkMetadata(_ controller: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.imageProvider = NSItemProvider(object: image)
        if let icon = Self.appIcon {
            metadata.iconProvider = NSItemProvider(object: icon)
        }
        return metadata
    }

    /// Loads the largest available app icon from the bundle's asset catalog.
    static let appIcon: UIImage? = {
        guard
            let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primary = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let files = primary["CFBundleIconFiles"] as? [String],
            let lastName = files.last
        else { return nil }
        return UIImage(named: lastName)
    }()
}
