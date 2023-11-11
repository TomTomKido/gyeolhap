//
//  EasyOXViewController.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/29.
//

import UIKit
import GameKit

class EasyOXViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    private let screenName = "easyOX"
    private let gameCenterManager = GameCenterManager()
    private var bestScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRecordLabel()
    }
    
    private func setUpRecordLabel() {
        let winStreakNumber = UserDefaults.standard.integer(forKey: "winStreak")
        recordLabel.text = "연승게임: \(winStreakNumber)연승 | ??등 "

        Task {
            do {
                let (streakRank, _) = try await gameCenterManager.getRank(of: .oxWinStreak)
                recordLabel.text = "연승게임: \(winStreakNumber)연승 | \(streakRank)등"
            } catch {
                print("Error: Failed to fetch rank from leaderboard")
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func leaderboardTapped(_ sender: Any) {
        gameCenterManager.presentLeaderboard(of: .oxWinStreak, on: self)
    }
    
    
    @IBAction func startTapped(_ sender: Any) {
        let easyOXStoryboard = UIStoryboard.init(name: "EasyOXGame", bundle: nil)
        guard let easyOXVC = easyOXStoryboard.instantiateViewController(identifier: "EasyOXGameVC") as? EasyOXGameViewController else { return }
        easyOXVC.delegate = self
        self.navigationController?.pushViewController(easyOXVC, animated: true)
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "easyOXGameButton")
    }
}

extension EasyOXViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

extension EasyOXViewController: OXGameScorePassDelegate {
    func update(score: Int) {
        if score > bestScore {
            bestScore = score
            UserDefaults.standard.set(bestScore, forKey: "winStreak")
            gameCenterManager.submitScore(to: .oxWinStreak, score: bestScore)
            setUpRecordLabel()
        }
    }
}

protocol OXGameScorePassDelegate {
    func update(score: Int)
}
