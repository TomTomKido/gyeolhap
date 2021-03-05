//
//  stageManager.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/10.
//

import UIKit

class StageManager {
    static let shared = StageManager()
    
    var Stages:[Stage] = []
    let stageCount: Int = 20
    var currentStage: Stage?
    
    private init() {
        self.Stages = createRawStages(size: stageCount)
    }
    
    func createRawStages(size: Int) -> [Stage] {
        var newRawStages: [Stage] = []
        
        for i in 1...size {
            let rawStage = Stage(id: i, dataArray: nineRandomNumberFrom0To26())
            newRawStages.append(rawStage)
        }
        return newRawStages
    }
    
    func nineRandomNumberFrom0To26() -> Array<Int> {
        let sequence = 0 ..< 27
        let shuffledSequence = sequence.shuffled()
        return Array(shuffledSequence[0...8])
    }
     
    func stage(at index: Int) -> Stage? {
        return Stages[index]
    }
    
    func saveRecord(second: Int) {
        
    }
    
    func printSolvedStatus ()
    {
        for stage in Stages {
            print("전체 스테이지 상황", stage.id, stage.isSolved)
        }
    }
    
    func solveStage(at index: Int) {
        Stages[index].isSolved = true
    }
    
    func getRecord(at index: Int, second: String) {
        Stages[index].record = second
    }
    
}
