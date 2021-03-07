//
//  StageRealm.swift
//  GyeolHap
//
//  Created by TaeHyeok LEE on 2021/03/06.
//

import Foundation

import RealmSwift

class StageRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var randomNumberString: String? = nil
    @objc dynamic var isSolved = false
    @objc dynamic var record = ""
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(StageRealm.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(_ arrayData: [Int]) {
        self.init()
        self.id = incrementID()
        self.randomNumberString = arrayData.map { String(describing: $0) }.joined(separator: ",")
    }
    
    func getArrayData() -> [Int]{
        guard let randomNumberString = self.randomNumberString else { return [] }
        let randomNumberArray = randomNumberString.components(separatedBy: ",").compactMap { Int($0) }
        return randomNumberArray
    }
    
    
}


