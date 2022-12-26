import UIKit

// MARK: - TimerViewDelegate protocol
protocol TimerViewDelegate: AnyObject {
    func startTimer(hours: Float, minutes: Float, seconds: Float)
    func pauseTimer()
    func resetTimer()
}

// MARK: - TimerView
final class TimerView: UIView {

    // MARK: - Properties and Initializers
    weak var delegate: TimerViewDelegate?

    private lazy var timeSetStackView: UIStackView = {
        let stackView = makeStackView(axis: .vertical, alignment: .fill, distribution: .fill)
        stackView.toAutolayout()
        return stackView
    }()

    private lazy var timeControlStackView: UIStackView = {
        let stackView = makeStackView(axis: .vertical, alignment: .fill, distribution: .fill)
        stackView.toAutolayout()
        return stackView
    }()

    private lazy var hoursSlider: UISlider = {
        makeSlider(withMaxValue: 24, andAction: #selector(hoursChanged))
    }()

    private lazy var minutesSlider: UISlider = {
        makeSlider(withMaxValue: 60, andAction: #selector(minutesChanged))
    }()

    private lazy var secondsSlider: UISlider = {
        makeSlider(withMaxValue: 60, andAction: #selector(secondsChanged))
    }()

    private lazy var hoursLabel: UILabel = {
        makeLabel(text: "", alignment: .right)
    }()

    private lazy var minutesLabel: UILabel = {
        makeLabel(text: "", alignment: .right)
    }()

    private lazy var secondsLabel: UILabel = {
        makeLabel(text: "", alignment: .right)
    }()

    lazy var timeLeftLabel: UILabel = {
        makeLabel(text: "", alignment: .right)
    }()

    var timeProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.toAutolayout()
        progressView.progressTintColor = .astOliveDark
        progressView.trackTintColor = .astGrayLight
        return progressView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        toAutolayout()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
private extension TimerView {

    @objc private func hoursChanged() {
        hoursLabel.text = String(Int(hoursSlider.value))
    }

    @objc private func minutesChanged() {
        minutesLabel.text = String(Int(minutesSlider.value))
    }

    @objc private func secondsChanged() {
        secondsLabel.text = String(Int(secondsSlider.value))
    }

    @objc private func startButtonPressed() {
        hoursSlider.isUserInteractionEnabled = false
        minutesSlider.isUserInteractionEnabled = false
        secondsSlider.isUserInteractionEnabled = false
        delegate?.startTimer(hours: hoursSlider.value, minutes: minutesSlider.value, seconds: secondsSlider.value)
    }

    @objc private func pauseButtonPressed() {
        delegate?.pauseTimer()
    }

    @objc private func resetButtonPressed() {
        hoursSlider.value = 0
        minutesSlider.value = 0
        secondsSlider.value = 0
        hoursLabel.text = ""
        minutesLabel.text = ""
        secondsLabel.text = ""
        timeLeftLabel.text = ""
        timeProgressView.progress = 0

        hoursSlider.isUserInteractionEnabled = true
        minutesSlider.isUserInteractionEnabled = true
        secondsSlider.isUserInteractionEnabled = true

        delegate?.resetTimer()
    }

    private func addSubviews() {
        for element in prepareUIElementsForTimeSet() {
            timeSetStackView.addArrangedSubview(element)
        }
        for element in prepareUIElementsForTimeControl() {
            timeControlStackView.addArrangedSubview(element)
        }
        addSubview(timeSetStackView)
        addSubview(timeControlStackView)
    }

    private func setupConstraints() {
        let constraints = [
            timeSetStackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            timeSetStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            timeSetStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            timeControlStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            timeControlStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            timeControlStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func prepareUIElementsForTimeSet() -> [UIStackView] {
        let timeSetUIElements = [
            makeStackView(axis: .horizontal, alignment: .fill, distribution: .fill,
                                                                  withItems: [
                                                                    makeLabel(text: "Hours:", alignment: .left),
                                                                    hoursLabel
                                                                  ]),
            makeStackView(axis: .horizontal, alignment: .fill, distribution: .fill,
                                                                  withItems: [
                                                                    makeLabel(text: "0", alignment: .left),
                                                                    hoursSlider,
                                                                    makeLabel(text: "24", alignment: .right)
                                                                  ]),
            makeStackView(axis: .horizontal, alignment: .fill, distribution: .fill,
                                                                  withItems: [
                                                                    makeLabel(text: "Minutes:", alignment: .left),
                                                                    minutesLabel
                                                                  ]),
            makeStackView(axis: .horizontal, alignment: .fill, distribution: .fill,
                                                                  withItems: [
                                                                    makeLabel(text: "0", alignment: .left),
                                                                    minutesSlider,
                                                                    makeLabel(text: "60", alignment: .right)
                                                                  ]),
            makeStackView(axis: .horizontal, alignment: .fill, distribution: .fill,
                                                                  withItems: [
                                                                    makeLabel(text: "Seconds:", alignment: .left),
                                                                    secondsLabel
                                                                  ]),
            makeStackView(axis: .horizontal, alignment: .fill, distribution: .fill,
                                                                  withItems: [
                                                                    makeLabel(text: "0", alignment: .left),
                                                                    secondsSlider,
                                                                    makeLabel(text: "60", alignment: .right)
                                                                  ])
            ]
        return timeSetUIElements
    }

    func prepareUIElementsForTimeControl() -> [UIView] {
        let buttons = [
            makeButton(withTitle: "Start", imageName: "play.fill", color: .astGreen,
                       andAction: #selector(startButtonPressed)),
            makeButton(withTitle: "Pause", imageName: "pause.fill", color: .astYellow,
                       andAction: #selector(pauseButtonPressed)),
            makeButton(withTitle: "Reset", imageName: "arrow.clockwise", color: .astRed,
                       andAction: #selector(resetButtonPressed))
        ]

        let timeControlUIElements = [
            makeStackView(axis: .horizontal, alignment: .fill, distribution: .fill,
                                                                  withItems: [
                                                                    makeLabel(text: "Total:", alignment: .left),
                                                                    timeLeftLabel
                                                                  ]),
            timeProgressView,
            makeStackView(axis: .horizontal, alignment: .fill, distribution: .fill, withItems: buttons)
        ]
        return timeControlUIElements
    }

    private func makeStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment,
                               distribution: UIStackView.Distribution, withItems items: [UIView] = []
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.backgroundColor = .clear
        stackView.spacing = 16
        for item in items {
            stackView.addArrangedSubview(item)
        }
        return stackView
    }

    private func makeSlider(withMaxValue maxValue: Float, andAction action: Selector) -> UISlider {
        let slider = UISlider()
        slider.toAutolayout()
        slider.thumbTintColor = .astGrayDark
        slider.minimumTrackTintColor = .astOliveDark
        slider.maximumTrackTintColor = .astGrayLight
        slider.maximumValue = maxValue
        slider.addTarget(self, action: action, for: .valueChanged)
        return slider
    }

    private func makeLabel(text: String, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.font =  label.font.withSize(UIScreen.screenSize(dividedBy: 35))
        label.textAlignment = alignment
        label.numberOfLines = 0
        label.textColor = .astGrayDark
        label.text = text
        return label
    }

    private func makeButton(withTitle title: String, imageName: String, color: UIColor,
                            andAction action: Selector
    ) -> UIButton {
        var filled = UIButton.Configuration.filled()
        filled.buttonSize = .medium
        filled.baseBackgroundColor = color
        filled.baseForegroundColor = .astOliveDark
        filled.titleAlignment = .automatic
        filled.title = title
        filled.attributedTitle?.font = UIFont.systemFont(ofSize: UIScreen.screenSize(dividedBy: 40))
        filled.image = UIImage(systemName: imageName)
        filled.imagePlacement = .leading
        filled.imagePadding = 8
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
