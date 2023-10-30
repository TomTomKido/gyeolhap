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
    
    @IBOutlet weak var correctImage: UIImageView!
    @IBOutlet weak var wrongImage: UIImageView!
    
    private var timer: Timer?
    private var currentTime: TimeInterval = 0
    private var totalTime: TimeInterval = 5.05
    private let gameManager = OXGameManager()
    private var answer: Bool = false
    private var currentStage: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeGame()
    }
    
    private func initializeGame() {
        currentStage += 1
        gameTitle.text = "\(currentStage)연승 성공!"
        
        timerTimeLabel.text = "5"
        timerTimeLabel.alpha = 1
        
        currentTime = 0
        
        totalTime -= 0.05
        if totalTime <= 1 {
            totalTime = 1
        }
        timerTimeLabel.text = String(format: "%.2f", totalTime)
        if totalTime == 2 {
            timerTimeLabel.textColor = UIColor.hotpink
            timerFillView.backgroundColor = UIColor.hotpink
        }
        
        setupQuestionTiles()
        startTimer()
    }
    
    private func setupQuestionTiles() {
        let (question, isHap) = gameManager.getOXQuestion()
        tile1.image = UIImage(named: "tile\(question[0])")
        tile2.image = UIImage(named: "tile\(question[1])")
        tile3.image = UIImage(named: "tile\(question[2])")
        self.answer = isHap
    }
    
    private func stopGame() {
        timer?.invalidate()
        timer = nil
        timerTimeLabel.alpha = 0
        timerFillViewWidth.constant = 0
        view.layoutIfNeeded()
    }
    
    private func startTimer() {
        currentTime = 0
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    private func choose(trialAnswer: Bool, timeover: Bool? = nil) {
        stopGame()
        
        if let _ = timeover {
            showAnimation(isCorrect: false) { [weak self] in
                guard let self else { return }
                AlertManager.showAlert(at: self, message: "시간을 초과했습니다.\n\(self.currentStage)연승 성공!", okActionMessage: "확인") { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            return
        }
        
        if answer == trialAnswer {
            showAnimation(isCorrect: true) { [weak self] in
                self?.initializeGame()
            }
        } else {
            showAnimation(isCorrect: false) { [weak self] in
                guard let self else { return }
                AlertManager.showAlert(at: self, message: "틀렸습니다.\n\(self.currentStage)연승 성공!", okActionMessage: "확인") { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func showAnimation(isCorrect: Bool, completionHandler: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            if isCorrect {
                self?.correctImage.alpha = 1
            } else {
                self?.wrongImage.alpha = 1
            }
        } completion: { [weak self] _ in
            if isCorrect {
                self?.correctImage.alpha = 0
            } else {
                self?.wrongImage.alpha = 0
            }
            completionHandler()
        }
    }
        
    @objc func updateTimer() {
        currentTime += 0.01
        let percentage = 0.01 / totalTime

        timerFillViewWidth.constant -= timerBackgroundView.frame.width * CGFloat(percentage)
        view.layoutIfNeeded()
        
        if currentTime >= totalTime {
            choose(trialAnswer: false, timeover: true)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hapButtonTapped(_ sender: Any) {
        choose(trialAnswer: true)
    }
    
    @IBAction func gyeolButtonTapped(_ sender: Any) {
        choose(trialAnswer: false)
    }
    
}
