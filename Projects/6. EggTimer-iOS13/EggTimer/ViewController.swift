//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var progressBarView: UIProgressView!
    var player: AVAudioPlayer?
    
    let eggTime = ["Soft": 3, "Medium": 4, "Hard": 7]
    
    var secondsRemaining = 60
    var timer = Timer()
    var totalTime : Float = 0
    var secondsPassed : Float = 0
    
    
    @objc func updateCounter() {
        //example functionality
        
        let percentageProgress = secondsPassed / totalTime
        progressBarView.progress = percentageProgress
        if secondsPassed < totalTime {
            secondsPassed += 1
        } else {
            timer.invalidate()
            titleLabel.text = "DONE!"
            playSound()
        }
    }

    @IBAction func hardnessSelected(_ sender: UIButton) {
        stopSound()
        progressBarView.progress = 0
        totalTime = 0
        secondsPassed = 0
        timer.invalidate()
        let hardness = sender.currentTitle!
        titleLabel.text = hardness
        secondsRemaining = eggTime[hardness]!
        totalTime = Float(eggTime[hardness]!)

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func loveCalculator() {
        let loveScore = Int.random(in: 0...100)
        
        if loveScore == 100 {
            print("1")
        } else {
            print("2")
        }
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player?.play()
    }
    
    func stopSound() {
        player?.stop()
    }
}
