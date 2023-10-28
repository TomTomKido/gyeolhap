//
//  CloudManager.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/14.
//

import Foundation
import CloudKit
import RealmSwift


class CloudManager {
    static let shared = CloudManager()
    
    var didMoveToiCloud: Bool
    
    var stageSolveData: [StageRecordData] = []
    
    var canAccessiCloud: Bool = false
    
    private init() {
        didMoveToiCloud = UserDefaults.standard.bool(forKey: "didMoveToiCloud")
        stageSolveData = mergedLocalAndiCloud()
        NotificationCenter.default.addObserver(self, selector: #selector(iCloudDataChanged), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default)
        
        checkiCloudStatus()
    }
    
    func checkiCloudStatus() {
//        CKContainer.default().accountStatus { [weak self] (accountStatus, error) in
//            switch accountStatus {
//            case .available:
//                self?.canAccessiCloud = true
//            case .noAccount, .restricted, .couldNotDetermine, .temporarilyUnavailable:
//                self?.canAccessiCloud = false
//            @unknown default:
//                self?.canAccessiCloud = false
//            }
//        }
    }
    
    func initialDataSync() {
        // Check if local data exists
        let localDataExists = StageRealm.all().count == 1000

        // Fetch iCloud data
        let iCloudData = NSUbiquitousKeyValueStore.default.string(forKey: "gameData")

        // If local data exists and iCloud is empty, upload local data to iCloud
        if localDataExists && iCloudData == nil {
            updateToiCloud()
        } else if !localDataExists && iCloudData != nil {
            iCloudDataChanged()
        } else if localDataExists && iCloudData != nil {
            iCloudData
        }
    }
    
    // MARK: when local changes
    func updateToiCloud() {
        stageSolveData = mergedLocalAndiCloud()
        do {
            let jsonData = try JSONEncoder().encode(stageSolveData)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                NSUbiquitousKeyValueStore.default.set(jsonString, forKey: "gameData")
            }
        } catch {
            print("StageRealm encoding failed.")
        }
    }
    
    // MARK: when iCloud changes
    @objc func iCloudDataChanged() {
        stageSolveData = mergedLocalAndiCloud()
    }

    // MARK: merge local and icloud if can access icloud
    func mergedLocalAndiCloud() -> [StageRecordData] {
        let items = StageRealm.all()
        let localData = Array(items.map { StageRecordData(from: $0) })
        
        let sortedLocalData = localData.sorted { $0.stageId < $1.stageId }
        
        if let iCloudData = getiCloudDataIfCanAccess() {
            let sortediCloudData = iCloudData.sorted { $0.stageId < $1.stageId }
            return sortedLocalData.enumerated().map { (index, localRecord) in
                if sortediCloudData.count <= index {
                    return localRecord
                } else {
                    let iCloudRecord = sortediCloudData[index]
                    let stageId = localRecord.stageId
                    let isSolved = StageRecordData.SolvedStatus(rawValue: max(localRecord.isSolved.rawValue, iCloudRecord.isSolved.rawValue)) ?? .unsolved
                    let record = min(localRecord.record, iCloudRecord.record)
                    return StageRecordData(stageId: stageId, isSolved: isSolved, record: record)
                }
            }
        } else {
            return localData
        }
    }

    func getiCloudDataIfCanAccess() -> [StageRecordData]? {
        guard canAccessiCloud else { return nil }
        if let jsonString = NSUbiquitousKeyValueStore.default.string(forKey: "gameData"),
           let jsonData = jsonString.data(using: .utf8),
           let decodedItems = try? JSONDecoder().decode([StageRecordData].self, from: jsonData) {
            return decodedItems
        }
        return nil
    }
}

struct StageRecordData: Codable {
    let stageId: Int
    let isSolved: SolvedStatus
    let record: Int
    
    enum SolvedStatus: Int, Codable {
        case unsolved = 0
        case failed
        case solved
    }
    
    func toStageRealm() -> StageRealm {
        let stageRealm = StageRealm()
        stageRealm.stageId = self.stageId
        stageRealm.isSolved = StageRealm.SolvedStatus(rawValue: self.isSolved.rawValue) ?? .unsolved
        stageRealm.recordString = self.record.timeString()
        stageRealm.record = self.record
        return stageRealm
    }
}

extension StageRecordData {
    init(from stageRealm: StageRealm) {
        self.stageId = stageRealm.stageId
        self.isSolved = SolvedStatus(rawValue: stageRealm.isSolved.rawValue) ?? .unsolved
        self.record = stageRealm.record
    }
}
