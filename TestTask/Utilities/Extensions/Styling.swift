//
//  Styling.swift
//  TestTask
//
//  Created by Nyazik Byashimova on 31.08.2022.
//

import Foundation
import UIKit

enum GothamFontWeight: String {
    case black
    case book
    case medium
    case bold
}


class Styling {
    
    static func fontGothamFontWeight(weight: GothamFontWeight, size: Float) -> UIFont {
        if let font = UIFont.init(name: "Gotham-\(weight.rawValue.capitalized)", size: CGFloat(size)) {
            return font
        }
        else {
            return UIFont.systemFont(ofSize: CGFloat(size))
        }
    }
    
}
