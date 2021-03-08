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
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var stageId: Int = 0
    @objc dynamic var randomNumberString: String? = nil
    @objc dynamic var isSolved = false
    @objc dynamic var record = ""
    
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
    
    func solve(second: String) {
        guard let realm = realm else { return }
        try! realm.write {
            isSolved = true
            //TODO: record문자열로 변환해서 저장하는 거 구현
            self.record = second
        }
    }

}

