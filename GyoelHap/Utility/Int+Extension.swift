//
//  TimeInterval+Extension.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/18.
//

import Foundation

extension Int {
    func timeString() -> String {
        return TimeInterval(self).timeString()
    }
}

extension Double {
    func timeString() -> String {
        let newTime = self / 10
        let hours = Int(newTime) / 3600
        let minutes = Int(newTime) / 60 % 60
        let seconds = Int(newTime) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
