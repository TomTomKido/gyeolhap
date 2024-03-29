//
//  StageRealm.swift
//  GyeolHap
//
//  Created by TaeHyeok LEE on 2021/03/06.
//

import Foundation
import RealmSwift

class StageRealm: Object {
    enum Property: String{
        case id, stageId, randomNumberString, isSolved, record
    }
    
    @objc enum SolvedStatus: Int, RealmEnum {
        case unsolved = 0
        case solved
        case failed
    }
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var stageId: Int = 0
    @objc dynamic var randomNumberString: String? = nil
    @objc dynamic var isSolved: SolvedStatus = .unsolved
    @objc dynamic var recordString = ""
    @objc dynamic var record: Int = 9999999999
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(StageRealm.self).max(ofProperty: "stageId") as Int? ?? 0) + 1
    }
    
    override static func primaryKey() -> String? {
        return StageRealm.Property.id.rawValue
    }
    
    convenience init(_ arrayData: [Int]) {
        self.init()
        self.stageId = incrementID()
        self.randomNumberString = arrayData.map { String(describing: $0) }.joined(separator: ",")
    }
    
    func getArrayData() -> [Int]{
        guard let randomNumberString = self.randomNumberString else { return [] }
        let randomNumberArray = randomNumberString.components(separatedBy: ",").compactMap { Int($0) }
        return randomNumberArray
    }
}

extension StageRealm {
    static func all(in realm: Realm = try! Realm()) -> Results<StageRealm> {
        return realm.objects(StageRealm.self).sorted(byKeyPath: StageRealm.Property.stageId.rawValue)
    }
    
    func solve(secondString: String, second: Int) {
        guard let realm = realm else { return }
        try! realm.write {
            isSolved = .solved
            self.recordString = secondString
            self.record = second
        }
    }
    
    func fail() {
        guard let realm = realm else { return }
        try! realm.write {
            isSolved = .failed
            self.recordString = "fail"
            self.record = -1
        }
    }
}

extension StageRealm {
    static func getSolvedStageData() -> Int {
        let items = StageRealm.all()
        //item in items has  isSolved property. I want to get the number of all items in which isSolved property is true
        let solvedItems = items.filter { $0.isSolved == .solved }
        return solvedItems.count
    }
    
    static func getAverageClearTimeData() -> Double? {
        let items = StageRealm.all()
        let solvedItems = items.filter { $0.isSolved == .solved }
        if solvedItems.count > 0 {
            let totalClearTime = solvedItems.reduce(0) { $0 + $1.record }
            let averageClearTime = Double(totalClearTime) / Double(solvedItems.count)
            return averageClearTime
        }
        return nil
    }
}
