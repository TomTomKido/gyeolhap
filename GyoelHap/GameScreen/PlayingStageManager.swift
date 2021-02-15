//
//  PlayingStageManager.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/15.
//

import Foundation

class PlayingStageManager {
    
    var playingStage:PlayingStage?
    
    init(stage: Stage) {
        self.playingStage = convertToStage(stage: stage)
    }
    
    func convertToStage(stage: Stage) -> PlayingStage {
        let playingStage = PlayingStage(id: stage.id, dataArray: stage.dataArray)
        return playingStage
    }
    
//    func parseStage(rawStage: Stage) -> PlayingStage {
//        let colors: [Int] = getColors(array: rawStage.dataArray)
//        let shapes: [Int] = getShapes(array: rawStage.dataArray)
//        let BGColors: [Int] = getBGColors(array: rawStage.dataArray)
//        return Stage(id:rawStage.id, colors: colors, shapes: shapes, BGColors: BGColors)
//    }

    func getColors(array: [Int]) -> [Int] {
        //0: pink, 1: dark blue, 2: yellow
        var newArray: [Int] = []

        for raw in 0..<array.count {
            let color: Int = array[raw] % 3
            newArray.append(color)
        }
        return newArray
    }

    func getShapes(array: [Int]) -> [Int] {
        //0: star, 1: moon, 2: sun
        var newArray: [Int] = []

        for raw in 0..<array.count {
            let shape: Int = Int(floor(Double(array[raw] / 3))) % 3
            newArray.append(shape)
        }
        return newArray
    }

    func getBGColors(array: [Int]) -> [Int] {
        //0: red, 1: purple, 2: green
        var newArray: [Int] = []

        for raw in 0..<array.count {
            let BGColor: Int = Int(floor(Double(Int(floor(Double(array[raw] / 3))) / 3))) % 3
            newArray.append(BGColor)
        }
        return newArray
    }
}
