//
//  AlertHelper.swift
//  TestTask
//
//  Created by Nyazik Byashimova on 1.09.2022.
//

import Foundation
import UIKit

class AlertHelper {
    static func showAlert(presentingScreen: UIViewController, title: String, message: String, actionTitle: String, actionHandler: @escaping () -> Void = {}) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            
            actionHandler()
        }
        
        alert.addAction(action)
        
        presentingScreen.present(alert, animated: false, completion: nil)
    }
}
