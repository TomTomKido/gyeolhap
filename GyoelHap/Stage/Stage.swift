//
//  stage.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/10.
//

import UIKit

struct Stage {
    let id: Int
    let dataArray: [Int]
    var isSolved: Bool = false {
        didSet {
            print("값이 \(oldValue)에서 \(isSolved)로 바뀜")
        }
    }
    var record: String?
    
    init(id: Int, dataArray: [Int]) {
        self.id = id
        self.dataArray = dataArray
    }
    
    
}
