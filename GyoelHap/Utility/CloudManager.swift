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
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(iCloudDataChanged), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default)
    }
    
    struct StageRealmCodable: Codable {
        let id: String
        let stageId: Int
        let randomNumberString: String?
        let isSolved: Int
        let recordString: String
        let record: Int
        
        init(from stageRealm: StageRealm) {
            self.id = stageRealm.id
            self.stageId = stageRealm.stageId
            self.randomNumberString = stageRealm.randomNumberString
            self.isSolved = stageRealm.isSolved.rawValue
            self.recordString = stageRealm.recordString
            self.record = stageRealm.record
        }
        
        func toStageRealm() -> StageRealm {
            let stageRealm = StageRealm()
            stageRealm.id = self.id
            stageRealm.stageId = self.stageId
            stageRealm.randomNumberString = self.randomNumberString
            stageRealm.isSolved = StageRealm.SolvedStatus(rawValue: self.isSolved) ?? .unsolved
            stageRealm.recordString = self.recordString
            stageRealm.record = self.record
            return stageRealm
        }
    }
    
    func updateToiCloud() {
        let items = StageRealm.all()
        let codableItems = Array(items.map { StageRealmCodable(from: $0) })
        do {
            let jsonData = try JSONEncoder().encode(codableItems)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                NSUbiquitousKeyValueStore.default.set(jsonString, forKey: "gameData")
            }
        } catch {
            print("StageRealm encoding failed.")
        }
    }
    
    @objc func iCloudDataChanged() {
        if let jsonString = NSUbiquitousKeyValueStore.default.string(forKey: "gameData"),
           let jsonData = jsonString.data(using: .utf8) {
            do {
                let decodedItems = try JSONDecoder().decode([StageRealmCodable].self, from: jsonData)
                let items = decodedItems.map { $0.toStageRealm() }
                let realm = try! Realm()
                try! realm.write {
                    realm.add(items, update: .modified)
                }
            } catch {
                print("StageRealm decoding failed")
            }
        }
    }
}
