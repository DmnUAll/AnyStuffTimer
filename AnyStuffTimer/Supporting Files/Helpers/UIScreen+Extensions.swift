import UIKit

extension UIScreen {

    static func screenSize(dividedBy divider: CGFloat) -> CGFloat {
        return self.main.bounds.height / divider
    }
}
