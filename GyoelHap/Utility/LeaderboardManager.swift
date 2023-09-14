//
//  LeaderboardManager.swift
//  GyeolHap
//
//  Created by terry.yes on 2023/09/13.
//

import Foundation
import GameKit

enum LeaderboardType {
    case clearStage
    case playTime
    
    var leaderboardId: String {
        switch self {
        case .clearStage:
            return "com.taelee.GyeolHapTomKido.WeeklyClearStages"
        case .playTime:
            return "com.taelee.GyeolHapTomKido.AveragePlayTime"
//            return "com.taelee.GyeolHapTomKido.ClearPlayTime"
        }
    }
}

enum GameCenterError: Error, LocalizedError {
    case notAuthenticated
    case leaderboardNotFound
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "User is not authenticated with Game Center."
        case .leaderboardNotFound:
            return "The requested leaderboard could not be found."
        }
    }
}


class GameCenterManager: NSObject {
    private func isUserAuthenticated() -> Bool {
        let localPlayer = GKLocalPlayer.local
        return localPlayer.isAuthenticated
    }
    
    func getRank(of type: LeaderboardType) async throws -> (rank: Int, score: Int) {
        let isLogin = isUserAuthenticated()

        guard isLogin == true else {
            throw GameCenterError.notAuthenticated
        }
        
        let leaderboardId = type.leaderboardId
        let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [leaderboardId])
        
        guard let leaderboard = leaderboards.first(where: { $0.baseLeaderboardID == leaderboardId }) else {
            throw GameCenterError.leaderboardNotFound
        }
        
        let (localPlayerEntry, otherPlayEntries) = try await leaderboard.loadEntries(for: [GKLocalPlayer.local], timeScope: .week)
        
        guard let myEntry = localPlayerEntry else {
            throw GameCenterError.leaderboardNotFound
        }
        return (rank: myEntry.rank, score: myEntry.score)
    }
    
    func presentLeaderboard(of type: LeaderboardType, on viewController: UIViewController & GKGameCenterControllerDelegate) {
        // Make sure the user is authenticated with Game Center
        guard GKLocalPlayer.local.isAuthenticated else {
            print("User is not authenticated with Game Center.")
            return
        }
        
        // Create and configure the view controller
        let gameCenterViewController = GKGameCenterViewController(
            leaderboardID: type.leaderboardId,
            playerScope: .global,
            timeScope: .allTime
        )
        gameCenterViewController.gameCenterDelegate = viewController
        viewController.present(gameCenterViewController, animated: true)
    }
    
    func submitScore(to type: LeaderboardType, score: Int) {
        // Make sure the user is authenticated with Game Center
        guard GKLocalPlayer.local.isAuthenticated else {
            print(GameCenterError.notAuthenticated.localizedDescription)
            return
        }
        
        // Set the leaderboard ID and submit the score
        let leaderboardID = type.leaderboardId
        
        GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboardID]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription).")
            } else {
                print("Successfully submitted score.")
            }
        }
    }
}
