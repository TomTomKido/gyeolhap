//
//  PlayingStage.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/15.
//

import Foundation

struct CurrentStage {
    let colors: [Int]
    let shapes: [Int]
    let BGColors: [Int]

    init(colors: [Int], shapes: [Int], BGColors: [Int]) {
        self.colors = colors
        self.shapes = shapes
        self.BGColors = BGColors
    }
}
