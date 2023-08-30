//
//  GameCenter.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/08/30.
//

import Foundation
import GameKit

struct GameCenterManager {
    let score = GKScore(leaderboardIdentifier: "Your_Leaderboard_ID")
    
    func send(scoreValue: Int) {
        score.value = Int64(scoreValue)
        GKScore.report([score]) { error in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
}
