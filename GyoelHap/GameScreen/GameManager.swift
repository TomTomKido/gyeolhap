//
//  PlayingStageManager.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/15.
//

import Foundation
import RealmSwift

enum HapType {
    case hap
    case submittedAnswer
    case wrongAnswer
}

class GameManager {
    
    private let stage:StageRealm
    private var answers: [[Int]] = []
    private var tryList: [Int] = []
    private var revealedAnswers: [[Int]] = []
    private(set) var currentHint: [Int] = []
    private var sortedRevealedAnswers: [[Int]] = []
    private var revealedHints: [[Int]] = []
    
    var hintArray: (shape: [Int], bgColor: [Int], color: [Int])?
    
    init(stage: StageRealm) {
        self.stage = stage
        loadAnswerLists(stage: stage)
    }
    
    func loadAnswerLists(stage: StageRealm) {
        answers = solver(stage: stage)
    }
    
    func addToTryList(_ num: Int) {
        if self.tryList.contains(num) {
            self.tryList = self.tryList.filter{$0 != num}
        } else if self.tryList.count < 3 {
            self.tryList.append(num)
        }
    }
//  TODO: Only for Debugging, remove when deploying
    func getAnswers() -> [[Int]] {
        return answers
    }
    func getTryList() -> [Int] {
        return tryList
    }
    func getRevealedAnswers() -> [[Int]] {
        return revealedAnswers
    }
    
    func getRevealedHints() -> [[Int]] {
        return revealedHints
    }
    func clearTryList() {
        self.tryList = []
    }
    
    func clearAllLists() {
        clearTryList()
        revealedAnswers = []
        sortedRevealedAnswers = []
    }
    
    func checkGyeol() -> (Bool) {
        if answers.count == revealedAnswers.count {
            print("결 성공")
            return true
        }
        print("결 실패")
        return false
    }
    
    

    func checkHap() -> HapType {
        var isHap = HapType.wrongAnswer
        
        if sortedRevealedAnswers.contains(tryList.sorted()) {
          print("제출했던 정답입니다.")
            isHap = .submittedAnswer
        } else if answers.contains(tryList.sorted()) {
            print("정답입니다")
//            isAnswer = true
            revealedAnswers.append(tryList)
            sortedRevealedAnswers.append(tryList.sorted())
            revealedHints.append(currentHint)
            currentHint = []
            isHap = .hap
        } else {
            //여기에 틀린답 정보 저장하기?
            print("오답입니다")
            isHap = .wrongAnswer
            print("제출한 정답: ", tryList)
            getHintNumbers()
        }
        tryList = []
        print("밝혀진 정답은 \(revealedAnswers)")
        return isHap
    }
    
    func getHintNumbers() {
        if self.tryList.count < 3 {
            return
        }
        let tryListSorted = self.tryList.sorted()
        print("tryListSorted: ", tryListSorted)
        print("arrayData: ", self.stage.getArrayData())
        let number0 = self.stage.getArrayData()[tryListSorted[0] - 1]
        let number1 = self.stage.getArrayData()[tryListSorted[1] - 1]
        let number2 = self.stage.getArrayData()[tryListSorted[2] - 1]
        
        let tryAnswer = [number0, number1, number2]
        
        let shapeHint = getShapeHint(tryAnswer)
        let bgColorHint = getBgColorHint(tryAnswer)
        let colorHint = getColorHint(tryAnswer)
        hintArray = (shapeHint, bgColorHint, colorHint)
    }
    private func getShapeHint(_ tryList: [Int]) -> [Int] {
        let shapeHint = tryList.map { num in
            return Int(floor(Double(num / 3))) % 3
        }
        return shapeHint
    }

    private func getBgColorHint(_ tryList: [Int]) -> [Int] {
        //tryList에 있는 숫자들을 3으로 나눈 몫을 리턴
        let bgColorHint = tryList.map { num in
            return Int(floor(Double(num / 3)))
        }
        return bgColorHint
    }

    private func getColorHint(_ tryList: [Int]) -> [Int] {
        //tryList에 있는 숫자들을 9으로 나눈 나머지를 리턴
        let colorHint = tryList.map { num in
            return num % 9
        }
        return colorHint
    }
    
    func isHint(index: Int) -> Bool {
        currentHint.contains(index + 1)
    }
    
    func printTryList() {
        print("현재 시도중: \(self.tryList)")
    }
    
    func getHint() -> [Int] {
        let unsolvedAnswers = answers.filter { sortedRevealedAnswers.contains($0) == false }
        if unsolvedAnswers.isEmpty {
            return []
        } else {
            let randomHint = unsolvedAnswers[0]
            currentHint = randomHint
            return randomHint
        }
    }
}

extension GameManager {
    func solver(stage: StageRealm) -> [[Int]] {
        var answers: [[Int]] = []
        let dataArray = stage.getArrayData()
        let colors: [Int] = getColors(array: dataArray)
        let shapes: [Int] = getShapes(array: dataArray)
        let BGColors: [Int] = getBGColors(array: dataArray)
        
        for i in 0 ..< 9 {
            for j in i + 1 ..< 9 {
                for k in j + 1 ..< 9 {
                    if (colors[i] + colors[j] + colors[k]) % 3 != 0 { continue }
                    if (shapes[i] + shapes[j] + shapes[k]) % 3 != 0 { continue }
                    if (BGColors[i] + BGColors[j] + BGColors[k]) % 3 != 0 { continue }
                    var answer : [Int] = Array()
                    answer.append(i + 1)
                    answer.append(j + 1)
                    answer.append(k + 1)
                    answers.append(answer)
                }
            }
        }
        return answers
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
}
