//
//  FavouriteMovieViewModel.swift
//  TestTask
//
//  Created by Nyazik Byashimova on 31.08.2022.
//

import UIKit
import RealmSwift

struct ListOfFavouriteMovieViewModel {
    let realm = try! Realm()
    var listOfFavouriteMoviewModel : Results<FavouriteListModel>
}

extension ListOfFavouriteMovieViewModel {
    
    func  numberOfRowInSection(_ sections: Int) -> Int {
        return self.listOfFavouriteMoviewModel.count
    }

    var numberOfSections : Int {
        return 1
    }

    func articleAtIndex(_ index : Int) -> FavouriteMovieViewModel {
        let favourite  = listOfFavouriteMoviewModel[index]
        return FavouriteMovieViewModel(favourite)
        
    }

}

struct FavouriteMovieViewModel {
    private let favouriteMoviewModel : FavouriteListModel
}

extension FavouriteMovieViewModel {
    init(_ favouriteMoviewModel : FavouriteListModel) {
        self.favouriteMoviewModel = favouriteMoviewModel
    }
}

extension FavouriteMovieViewModel {
    
    var name : String {
        self.favouriteMoviewModel.name
    }
    
    var year : Int {
        self.favouriteMoviewModel.year
    }
    
}


//MARK: - Check if valid to save
extension ListOfFavouriteMovieViewModel {
    
    func textFieldIsEmpty(titleTextField : String, yearTextField : String) -> Bool {
        if titleTextField == "" || yearTextField == "" || yearTextField.count != 4 {
            return false
        } else {
            return true
        }
    }
    
}

    //MARK: - Save Fav Movie
extension ListOfFavouriteMovieViewModel {
    
    func saveFav(name : String, year : String) {
        let favModel = FavouriteListModel()
        favModel.name = name
        favModel.year = Int(year) ?? 0
        do {
            try realm.write {
                realm.add(favModel)
            }
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
}

//MARK: - check if value already saved to DB
extension ListOfFavouriteMovieViewModel {
    
    func checkIfContains( name : String) -> Bool {
        var returnValue = false
        if listOfFavouriteMoviewModel.count > 0 {
            for fav in listOfFavouriteMoviewModel {
                if fav.name.contains(name) {
                    returnValue = false
                } else {
                    returnValue =  true
                }
            }
        } else {
            returnValue = true
        }
        return returnValue
    }
    
}
