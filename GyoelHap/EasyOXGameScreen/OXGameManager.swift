//
//  OXGameManager.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/30.
//

import Foundation

class OXGameManager {
    private func getOXQuestion(isHap: Bool) -> [Int] {
        var randomNumbers: Set<Int> = []
        randomNumbers.insert(Int.random(in: 0..<27))
        while randomNumbers.count < 2 {
            let randomNumber2 = Int.random(in: 0..<27)
            randomNumbers.insert(randomNumber2)
        }
        let randomNumbersArray = Array(randomNumbers)
        let randomNumber1 = randomNumbersArray[0]
        let randomNumber2 = randomNumbersArray[1]
        let colors: [Int] = GameManager.getColors(array: [randomNumber1, randomNumber2])
        let shapes: [Int] = GameManager.getShapes(array: [randomNumber1, randomNumber2])
        let BGColors: [Int] = GameManager.getBGColors(array: [randomNumber1, randomNumber2])
        var randomNumber3Hap: Int?
        for color in 0...2 {
            for shape in 0...2 {
                for BGColor in 0...2 {
                    if (colors[0] + colors[1] + color) % 3 != 0 { continue }
                    if (shapes[0] + shapes[1] + shape) % 3 != 0 { continue }
                    if (BGColors[0] + BGColors[1] + BGColor) % 3 != 0 { continue }
                    randomNumber3Hap = color + 3 * (shape + 3 * BGColor)
                }
            }
        }
        guard let randomNumber3Hap else { return [] }
        if isHap == true {
            return [randomNumber1, randomNumber2, randomNumber3Hap]
        } else {
            var randomNumber3NotHap: Int?
            while true {
                randomNumber3NotHap = Int.random(in: 0...26)
                if randomNumber3NotHap != randomNumber3Hap, randomNumber3NotHap != randomNumber1, randomNumber3NotHap != randomNumber2 {
                    break
                }
            }
            guard let randomNumber3NotHap else { return []}
            return [randomNumber1, randomNumber2, randomNumber3NotHap]
        }
    }
    
    func getOXQuestion() -> (question: [Int], isHap: Bool) {
        let isHap = Bool.random()
        let question = getOXQuestion(isHap: isHap)
        return (question: question, isHap: isHap)
    }
}
