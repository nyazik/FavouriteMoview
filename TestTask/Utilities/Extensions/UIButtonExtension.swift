//
//  UIButtonExtension.swift
//  TestTask
//
//  Created by Nyazik Byashimova on 31.08.2022.
//

import Foundation
import UIKit
extension UIButton {
    
    func applyBrownButtonStyling(text: String) {
        self.setTitle(text, for: .normal)
        self.setTitleColor(UIColor(red: 255, green: 255, blue: 255, alpha: 1), for: .normal)
        self.titleLabel?.font = Styling.fontGothamFontWeight(weight: .bold, size: 18)
        self.backgroundColor = .blue
        self.layer.cornerRadius = 5
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    }

}
