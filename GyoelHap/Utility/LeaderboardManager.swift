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
        print("asdfasdf login : ", isUserAuthenticated())
        let isLogin = isUserAuthenticated()

        guard isLogin == true else {
            print("asdfasdf 11111")
            throw GameCenterError.notAuthenticated
        }
        print("asdfasdf 1")
        
        let leaderboardId = type.leaderboardId
        let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [leaderboardId])
        
        print("asdfasdf 2")
        guard let leaderboard = leaderboards.first(where: { $0.baseLeaderboardID == leaderboardId }) else {
            print("asdfasdf 22222")
            throw GameCenterError.leaderboardNotFound
        }
        
        print("asdfasdf 3")
        let (localPlayerEntry, _) = try await leaderboard.loadEntries(for: [GKLocalPlayer.local], timeScope: .week)
        
        guard let myEntry = localPlayerEntry else {
            print("asdfasdf 33333")
            throw GameCenterError.leaderboardNotFound
        }
        print("asdfasdf 4")
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
