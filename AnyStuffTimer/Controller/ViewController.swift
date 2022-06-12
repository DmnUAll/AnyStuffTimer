//
//  ViewController.swift
//  AnyStuffTimer
//
//  Created by Илья Валито on 25.09.2021.
//

import UIKit
import AVFoundation // Allow us to use AudioPlayer to play sounds.

class ViewController: UIViewController {

    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var hoursSlider: UISlider!
    @IBOutlet weak var minutesSlider: UISlider!
    @IBOutlet weak var secondsSlider: UISlider!
    @IBOutlet weak var progressView: UIProgressView!
    
    var player: AVAudioPlayer!
    var timer = Timer()
    var totalTime: Int = 0
    var secondsPassed: Int = 0
    var savedData: (Int, Float, String) = (0, 0.0, "")
    
    // Playing the audiofile with a given name, from the Sounds folder.
    
    func playSound(_ soundName: String){
        
        let url = Bundle.main.url(forResource: soundName, withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
    
    // Updating the timer with steps in seconds.
    @objc func updateTimer() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            progressView.progress = Float(secondsPassed) / Float(totalTime)
            totalLabel.text = String(Int(totalLabel.text!)! - 1)
        } else {
            timer.invalidate()
            totalLabel.text = "DONE!"
            savedData = (0, 0.0, "")
            
            playSound("timer_finished")
        }
    }
    
    // Imitate the button pressing by shadowing the button for 0.2 seconds.
    func buttonsPressingImitation(_ sender: UIButton){
        sender.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { //delay for the code inside this block runing
            sender.alpha = 1
        }
    }
    
    @IBAction func hoursChanged(_ sender: UISlider) {
        
        
        hoursLabel.text = String(Int(sender.value))
        savedData = (0, 0.0, "")
    }
    
    @IBAction func minutesChanged(_ sender: UISlider) {
        
        minutesLabel.text = String(Int(sender.value))
        savedData = (0, 0.0, "")
    }
    
    @IBAction func secondsChanged(_ sender: UISlider) {
        
        secondsLabel.text = String(Int(sender.value))
        savedData = (0, 0.0, "")
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        playSound("button_pressed")
        buttonsPressingImitation(sender)
        timer.invalidate()
        
        totalTime = Int(hoursSlider.value) * 3600 + Int(minutesSlider.value) * 60 + Int(secondsSlider.value)
        totalLabel.text = String(totalTime)
        
        secondsPassed = savedData.0
        progressView.progress = savedData.1
        totalLabel.text = savedData.2 == "" ? String(totalTime) : savedData.2
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(updateTimer), userInfo:nil, repeats: true)
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        
        playSound("button_pressed")
        buttonsPressingImitation(sender)
        timer.invalidate()
        
        savedData.0 = secondsPassed
        savedData.1 = progressView.progress
        savedData.2 = totalLabel.text!
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        
        playSound("button_pressed")
        buttonsPressingImitation(sender)
        timer.invalidate()
        savedData = (0, 0.0, "")
        hoursLabel.text = "0"
        hoursSlider.value = 0
        minutesLabel.text = "0"
        minutesSlider.value = 0
        secondsLabel.text = "0"
        secondsSlider.value = 0
        totalLabel.text = ""
        progressView.progress = 0
    }
}

