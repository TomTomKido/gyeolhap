//
//  PlayingStageManager.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/15.
//

import Foundation

class CurrentStageManager {
    
    let stage:Stage
    var playingStage:CurrentStage?
    var answers: [[Int]]?
    
    init(stage: Stage) {
        self.stage = stage
        self.playingStage = convertToStage(stage: stage)
        self.answers = solver(playingStage: self.playingStage!)
    }
    
    func convertToStage(stage: Stage) -> CurrentStage {
        let colors: [Int] = getColors(array: stage.dataArray)
        let shapes: [Int] = getShapes(array: stage.dataArray)
        let BGColors: [Int] = getBGColors(array: stage.dataArray)

        let playingStage = CurrentStage(colors: colors, shapes: shapes, BGColors: BGColors)
        return playingStage
    }

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
    
    
    func solver(playingStage: CurrentStage) -> [[Int]] {
        var answers: [[Int]] = []
        for i in 0 ..< 9 {
            for j in i + 1 ..< 9 {
                for k in j + 1 ..< 9 {
                    let first0 = playingStage.colors[i]
                    let first1 = playingStage.shapes[i]
                    let first2 = playingStage.BGColors[i]
                    let second0 = playingStage.colors[j]
                    let second1 = playingStage.shapes[j]
                    let second2 = playingStage.BGColors[j]
                    let third0 = playingStage.colors[k]
                    let third1 = playingStage.shapes[k]
                    let third2 = playingStage.BGColors[k]
                    if (first0 + second0 + third0) % 3 == 0 {
                        if (first1 + second1 + third1) % 3 == 0 {
                            if (first2 + second2 + third2) % 3 == 0 {
                                var answer : [Int] = Array()
                                answer.append(i + 1)
                                answer.append(j + 1)
                                answer.append(k + 1)
                                answers.append(answer)
                            }
                        }
                    }
                }
            }
        }
        return answers
    }
}
