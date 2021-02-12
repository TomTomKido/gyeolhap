//
//  Initializer.swift
//  GyeolHap
//
//  Created by Terry Lee on 2020/12/27.
//

import Foundation

//Random number generator for tile number of 9 tiles
func randomNumberGen() -> Array<Int> {
    let sequence = 0 ..< 27
    let shuffledSequence = sequence.shuffled()
    return shuffledSequence
}

//Each number is between 0 and 26 inclusive. Since each tile needs to have 3 properties and it's caculated from tile number.
func numberToProperty(array : Array<Int>) -> [[Int]] {
    var propertyArray : [[Int]] = []
    for item in array {
        var num : Int = item
        var property : Array<Int> = Array()
        for _ in 0 ..< 3 {
            property.append(num % 3)
            num = Int(floor(Double(num / 3)))
        }
        propertyArray.append(property)
    }
    return propertyArray
}

//solver that caculates from tile properties.
func solver(array : [[Int]]) -> [[Int]] {
    var answers : [[Int]] = []
    for i in 0 ..< 9 {
        for j in i + 1 ..< 9 {
            for k in j + 1 ..< 9 {
                let first0 = array[i][0]
                let first1 = array[i][1]
                let first2 = array[i][2]
                let second0 = array[j][0]
                let second1 = array[j][1]
                let second2 = array[j][2]
                let third0 = array[k][0]
                let third1 = array[k][1]
                let third2 = array[k][2]
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
