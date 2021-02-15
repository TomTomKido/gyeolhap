//
//  stageManager.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/10.
//

import UIKit

class StageManager {
    static let shared = StageManager()
    
    var newStages:[NewStage] = []
//    var stages: [Stage] = []
    let stageCount: Int = 20
    var currentStageId: Int?
    var currentStage: NewStage?
    
    init() {
        self.newStages = createRawStages(size: stageCount)
//        self.stages = convertToStages(rawStages: self.stageDatas)
    }
    
    func createRawStages(size: Int) -> [NewStage] {
        var newRawStages: [NewStage] = []
        
        for i in 1...size {
            let rawStage = NewStage(id: i, dataArray: nineRandomNumberFrom0To26())
            newRawStages.append(rawStage)
        }
        return newRawStages
    }
    
    func nineRandomNumberFrom0To26() -> Array<Int> {
        let sequence = 0 ..< 27
        let shuffledSequence = sequence.shuffled()
        return Array(shuffledSequence[0...8])
    }
    
//    func convertToStages(rawStages: [StageData]) ->[Stage] {
//        var newStages: [Stage] = []
//
//        for i in 0..<rawStages.count {
//            let stage: Stage = parseStage(rawStage: rawStages[i])
//            newStages.append(stage)
//        }
//        return newStages
//    }
//
//    func parseStage(rawStage: StageData) -> Stage {
//        let colors: [Int] = getColors(array: rawStage.dataArray)
//        let shapes: [Int] = getShapes(array: rawStage.dataArray)
//        let BGColors: [Int] = getBGColors(array: rawStage.dataArray)
//        return Stage(id:rawStage.id, colors: colors, shapes: shapes, BGColors: BGColors)
//    }
//
//    func getColors(array: [Int]) -> [Int] {
//        //0: pink, 1: dark blue, 2: yellow
//        var newArray: [Int] = []
//
//        for raw in 0..<array.count {
//            let color: Int = array[raw] % 3
//            newArray.append(color)
//        }
//        return newArray
//    }
//
//    func getShapes(array: [Int]) -> [Int] {
//        //0: star, 1: moon, 2: sun
//        var newArray: [Int] = []
//
//        for raw in 0..<array.count {
//            let shape: Int = Int(floor(Double(array[raw] / 3))) % 3
//            newArray.append(shape)
//        }
//        return newArray
//    }
//
//    func getBGColors(array: [Int]) -> [Int] {
//        //0: red, 1: purple, 2: green
//        var newArray: [Int] = []
//
//        for raw in 0..<array.count {
//            let BGColor: Int = Int(floor(Double(Int(floor(Double(array[raw] / 3))) / 3))) % 3
//            newArray.append(BGColor)
//        }
//        return newArray
//    }
    
    func stage(at index: Int) -> NewStage? {
        return newStages[index]
    }
    
    func replaceCurrentStage(with item: NewStage?){
        self.currentStage = item
    }
    
}
