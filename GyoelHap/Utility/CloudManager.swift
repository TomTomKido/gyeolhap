//
//  CloudManager.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/26.
//

import Foundation
import CloudKit
import RealmSwift

class CloudManager {
    var canAccessiCloud: Bool = false
    
    init() {
        // TODO: 이거 다른 레포에서는 실행하면 에러 뜨던데 확인해보기
        CKContainer.default().accountStatus { [weak self] (accountStatus, error) in
            switch accountStatus {
            case .available:
                self?.canAccessiCloud = true
            case .noAccount, .restricted, .couldNotDetermine, .temporarilyUnavailable:
                self?.canAccessiCloud = false
            @unknown default:
                self?.canAccessiCloud = false
            }
        }
    }
    
    func backupToCloud() {
        let items = StageRealm.all()
        let localData = Array(items.map { StageRecordData(from: $0) }).sorted { $0.stageId < $1.stageId }
        do {
            let jsonData = try JSONEncoder().encode(localData)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                NSUbiquitousKeyValueStore.default.set(jsonString, forKey: "gameData")
            }
        } catch {
            print("StageRealm encoding failed.")
        }
    }
    
    private func getiCloudDataIfCanAccess() -> [StageRecordData]? {
        guard canAccessiCloud else { return nil }
        if let jsonString = NSUbiquitousKeyValueStore.default.string(forKey: "gameData"),
           let jsonData = jsonString.data(using: .utf8),
           let decodedItems = try? JSONDecoder().decode([StageRecordData].self, from: jsonData) {
            return decodedItems
        }
        return nil
    }
    
    func bringCloudData() {
        guard canAccessiCloud else { return }
        
        guard let jsonString = NSUbiquitousKeyValueStore.default.string(forKey: "gameData"),
           let jsonData = jsonString.data(using: .utf8),
           let decodedItems = try? JSONDecoder().decode([StageRecordData].self, from: jsonData) else {
            return
        }
        
        // TODO: 가져온 것을 realm에 저장해야함. 기존 데이터는 없애던가 합치던가.
//        guard let realm = realm else { return }
//        try! realm.write {
//            decodedItems.forEach {
//                realm.add($0.toStageRealm())
//            }
//        }
        
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
