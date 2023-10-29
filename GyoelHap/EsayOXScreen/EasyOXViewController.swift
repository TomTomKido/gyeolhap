//
//  EasyOXViewController.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/29.
//

import UIKit

class EasyOXViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    private let screenName = "easyOX"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRecordLabel()
    }
    
    private func setUpRecordLabel() {
//        let clearStageNumber = StageRealm.getSolvedStageData()
//        let allStageNumber = StageRealm.all().count
//        upperScoreInfoView.text = "클리어 스테이지: \(clearStageNumber) / \(allStageNumber) | ??등"
//
//        let averageClearTimeDouble = StageRealm.getAverageClearTimeData() ?? 0
//        let averageClearTimeString = timeString(time: TimeInterval(Int(averageClearTimeDouble)))
//        lowerScoreInfoView.text = "평균 클리어 시간: \(averageClearTimeString) | ??등"
//
//        Task {
//            do {
//                let (stageRank, _) = try await gameCenterManager.getRank(of: .clearStage)
//                upperScoreInfoView.text = "클리어 스테이지: \(clearStageNumber) / \(allStageNumber) | \(stageRank)등"
//
//                let (playTimeRank, _) = try await gameCenterManager.getRank(of: .playTime)
//                lowerScoreInfoView.text = "평균 클리어 시간: \(averageClearTimeString) | \(playTimeRank)등"
//            } catch {
//                print("Error: Failed to fetch rank from leaderboard")
//            }
//        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func leaderboardTapped(_ sender: Any) {
//        gameCenterManager.presentLeaderboard(of: .oxquiz, on: self)
    }
    
    
    @IBAction func startTapped(_ sender: Any) {
        let howToStoryboard = UIStoryboard.init(name: "EasyOXGame", bundle: nil)
        guard let howToVC = howToStoryboard.instantiateViewController(identifier: "EasyOXGameVC") as? EasyOXGameViewController else { return }
        self.navigationController?.pushViewController(howToVC, animated: true)
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "easyOXGameButton")
    }
    
}
