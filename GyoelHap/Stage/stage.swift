//
//  stage.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/10.
//

import UIKit

struct RawStage {
    let id: Int
    let stageRawArray: [Int]
    
    init(id: Int, stageRawArray: [Int]) {
        self.id = id
        self.stageRawArray = stageRawArray
    }
}

struct Stage {
    let id: Int
    let colors: [Int]
    let shapes: [Int]
    let BGColors: [Int]
    
    init(id:Int, colors: [Int], shapes: [Int], BGColors: [Int]) {
        self.id = id
        self.colors = colors
        self.shapes = shapes
        self.BGColors = BGColors
    }
}
