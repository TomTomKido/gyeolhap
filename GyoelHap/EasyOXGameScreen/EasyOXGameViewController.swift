//
//  EasyOXGameViewController.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/29.
//

import UIKit

class EasyOXGameViewController: UIViewController {
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var timerFillView: UIView!
    @IBOutlet weak var timerBackgroundView: UIView!
    @IBOutlet weak var timerTimeLabel: UILabel!
    
    @IBOutlet weak var tile1: UIImageView!
    @IBOutlet weak var tile2: UIImageView!
    @IBOutlet weak var tile3: UIImageView!
    @IBOutlet weak var timerFillViewWidth: NSLayoutConstraint!
    
    private var timer: Timer?
    private var currentTime: TimeInterval = 0
    private let totalTime: TimeInterval = 5
    override func viewDidLoad() {
        super.viewDidLoad()

        startTimer()
    }
    
    func startTimer() {

        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
        
    @objc func updateTimer() {
        timerTimeLabel.text = Int(ceil(totalTime - currentTime)).description
        
        currentTime += 0.01
        let percentage = 0.01 / totalTime

        timerFillViewWidth.constant -= timerBackgroundView.frame.width * CGFloat(percentage)
        view.layoutIfNeeded()
        
        if currentTime >= totalTime {
            timer?.invalidate()
            timerTimeLabel.text = "0"
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hapButtonTapped(_ sender: Any) {
        print("hap")
    }
    
    @IBAction func gyeolButtonTapped(_ sender: Any) {
        print("gyeol")
    }
    
}
