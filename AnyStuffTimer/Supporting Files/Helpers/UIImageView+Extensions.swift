import UIKit

extension UIImageView {

    static func setAsBackground(withImage imageName: String, to viewController: UIViewController) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.image = UIImage(named: imageName)
        viewController.view.insertSubview(backgroundImage, at: 0)
    }
}
