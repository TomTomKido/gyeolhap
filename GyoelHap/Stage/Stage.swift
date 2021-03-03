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
    var isSolved: Bool = false
    var record: Int?
    
    init(id: Int, dataArray: [Int]) {
        self.id = id
        self.dataArray = dataArray
    }
}
