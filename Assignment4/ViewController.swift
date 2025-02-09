//
//  ViewController.swift
//  Assignment4
//
//  Created by Ross Spafford on 2/9/25.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    
    //Timer for Current time
    var timer: Timer?
    
    //Timer for countdown
    var countdownTimer: Timer?
    
    var totalTime: TimeInterval = 0
    var audioPlayer: AVAudioPlayer?
    var isTimerRunning = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start the timer to update every second
        startCurrentTimer()
        
        
    }
    
    func startCurrentTimer() {
        // Invalidate the previous timer if it exists
        timer?.invalidate()
        
        // Schedule a timer to fire every second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateDateTimeLabel), userInfo: nil, repeats: true)
    }
    
    // Start/Stop button action
    @IBAction func startStopButtonTapped(_ sender: UIButton) {
        
            stopSound() // If the sound is playing, stop it without affecting the timer
      
            startCountdownTimer()
       
    }
    
    @objc func updateDateTimeLabel() {
        // Get the current date and time
        let currentDateTime = Date()
        
        // Create a DateFormatter to format the date and time
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss" // This matches "Wed, 28 Dec 2022 14:59:00"
        
        // Update the label with the formatted date and time
        dateTimeLabel.text = formatter.string(from: currentDateTime)
        
        // Check if it's AM or PM
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDateTime)
        
        if hour >= 12 {
            // It's PM, change the background to a different color (e.g., light blue for day)
            view.backgroundColor = UIColor.lightGray
        } else {
            // It's AM, change the background to another color (e.g., dark blue for night)
            view.backgroundColor = UIColor.darkGray
        }
    }
    
    // Start the countdown timer
    func startCountdownTimer() {
        totalTime = datePicker.countDownDuration
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdownTimer), userInfo: nil, repeats: true)
        isTimerRunning = true
        
    }
    
    // Update the label and check if time is up
    @objc func updateCountdownTimer() {
        if totalTime > 0 {
            totalTime -= 1
            timeRemainingLabel.text = formatTime(totalTime)
        } else {
            timeRemainingLabel.text = "Time's up!"
            playSound()
            stopCountdownTimer()
        }
    }
    
    // Stop the timer
    func stopCountdownTimer() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        isTimerRunning = false
        
    }
    
    // Play sound when timer ends
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "wav") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound")
        }
    }
    
    // Stop the sound
    func stopSound() {
        audioPlayer?.stop()
        stopCountdownTimer()
    }
    
    // Helper to format time as MM:SS
    func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop the timer when the view disappears
        timer?.invalidate()
    }}

