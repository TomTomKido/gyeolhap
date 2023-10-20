//
//  AlertManager.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/20.
//

import UIKit

class AlertManager {
    static func showAlert(at parent: UIViewController, title: String? = nil, message: String, okActionMessage: String, okHanlder: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionMessage, style: .default) { _ in
            okHanlder()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        parent.present(alert, animated: true)
    }
}
