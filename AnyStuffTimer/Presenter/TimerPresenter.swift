import UIKit
import MediaPlayer

// MARK: - TimerPresenter
final class TimerPresenter {

    // MARK: - Properties and Initializers
    weak var viewController: TimerController?
    private var player: AVAudioPlayer?
    private var timer = Timer()
    var timerData = TimerData()
    init(viewController: TimerController) {
        self.viewController = viewController
        viewController.timerView.delegate = self
    }
}

// MARK: - Helpers
private extension TimerPresenter {

    @objc private func updateTimer() {
        if timerData.secondsPassed < timerData.totalTime {
            timerData.secondsPassed += 1
            let progress = Float(timerData.secondsPassed) / Float(timerData.totalTime)
            viewController?.timerView.timeProgressView.progress = progress
            guard let timeLeft = Int(viewController?.timerView.timeLeftLabel.text ?? "") else { return }
            viewController?.timerView.timeLeftLabel.text = String(timeLeft - 1)
        } else {
            timer.invalidate()
            viewController?.timerView.timeLeftLabel.text = "DONE!"
            playSound("timer_finished")
        }
    }

    private func playSound(_ soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        guard let playerWithAudio = try? AVAudioPlayer(contentsOf: url) else { return }
        player = playerWithAudio
        player?.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            guard let self = self else { return }
            self.player?.stop()
            self.player = nil
        })
    }
}

// MARK: - TimerViewDelegate
extension TimerPresenter: TimerViewDelegate {

    func startTimer(hours: Float, minutes: Float, seconds: Float) {
        playSound("button_pressed")
        timer.invalidate()
        timerData.totalTime = Int(hours) * 3600 + Int(minutes) * 60 + Int(seconds)
        viewController?.timerView.timeProgressView.progress = timerData.progressState
        if timerData.secondsLeft == 0 {
            viewController?.timerView.timeLeftLabel.text = String(timerData.totalTime)
        } else {
            viewController?.timerView.timeLeftLabel.text = String(timerData.secondsLeft)
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }

    func pauseTimer() {
        playSound("button_pressed")
        timer.invalidate()

        guard let progress = viewController?.timerView.timeProgressView.progress else { return }
        guard let timeLeft = Int(viewController?.timerView.timeLeftLabel.text ?? "") else { return }
        timerData.progressState = progress
        timerData.secondsLeft = timeLeft
    }

    func resetTimer() {
        playSound("button_pressed")
        timer.invalidate()
        timerData.secondsPassed = 0
        timerData.progressState = 0
        timerData.secondsLeft = 0
    }
}
