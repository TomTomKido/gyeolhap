//
//  LogManager.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/08/28.
//

import Foundation
import FirebaseAnalytics
import UIKit

struct LogManager {
    static func sendButtonClickLog(screenName: String, buttonName: String) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterItemID: "\(screenName)_\(buttonName)",
            AnalyticsParameterItemName: buttonName
        ])
    }
    
    static func sendStageClickLog(screenName: String, buttonName: String, stageNumber: Int) {
        Analytics.logEvent("stage_click", parameters: [
          "screenName": screenName,
          "click_target": "\(buttonName)_button",
          "stage_number": stageNumber
        ])
    }
    
    static func sendScreenLog(screenName: String) {
        Analytics.logEvent("screen", parameters: [
          "screenName": screenName
        ])
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.lastScreenName = screenName
        }
    }
    
    static func sendAppLaunchLog() {
        Analytics.logEvent("app_launch", parameters: [:])
    }
    
    static func sendAppFinishLog(screenName: String) {
        Analytics.logEvent("app_finish", parameters: [
          "screenName": screenName
        ])
    }
}
