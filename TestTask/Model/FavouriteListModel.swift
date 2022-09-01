//
//  FavouriteListModel.swift
//  TestTask
//
//  Created by Nyazik Byashimova on 31.08.2022.
//

import Foundation
import RealmSwift

class FavouriteListModel : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var year : Int = 0
    
}
