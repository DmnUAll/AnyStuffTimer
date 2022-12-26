import UIKit

// MARK: - TimerController
final class TimerController: UIViewController {

    // MARK: - Properties and Initializers
    private var presenter: TimerPresenter?
    lazy var timerView: TimerView = {
        let uiView = TimerView()
        return uiView
    }()

    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.toAutolayout()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        presenter = TimerPresenter(viewController: self)
    }
}

// MARK: - Helpers
private extension TimerController {

    private func addSubviews() {
        view.insertSubview(backgroundImage, at: 0)
        view.addSubview(timerView)
    }

    private func setupConstraints() {
        let constraints = [
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            timerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            timerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            timerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            timerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
