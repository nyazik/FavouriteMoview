//
//  ViewController.swift
//  TestTask
//
//  Created by Nyazik Byashimova on 31.08.2022.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    let realm = try! Realm()
    var listOfFavouriteMovieViewModel : ListOfFavouriteMovieViewModel!
    var fav: Results<FavouriteListModel>?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegates()
        listOfFavouriteMovieViewModel = fetchFav()
        customizeUI()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
}

//MARK: - Delegates
extension MainViewController {
    func delegates() {
        tableView.dataSource = self
        tableView.delegate = self
        yearTextField.delegate = self
        titleTextField.delegate = self
    }
}

//MARK: - UI
extension MainViewController {
    
    func customizeUI() {
        titleTextField.placeholder = "Title"
        yearTextField.placeholder = "Year"
        addButton.backgroundColor = .lightGray
        addButton.applyBrownButtonStyling(text: "Add")
    }
    
    func changeFont(title: String, year : String) -> NSMutableAttributedString {
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.black]
        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.blue]
        let attributedString1 = NSMutableAttributedString(string: "\(title)" , attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string: " \(year)" , attributes:attrs2)
        attributedString1.append(attributedString2)
        return attributedString1
    }
    
}

//MARK: - Actions
extension MainViewController {
    
    @IBAction func addToFavourite(_ sender: Any) {
        
        guard let title = titleTextField.text, let year = yearTextField.text else { return }
        
        let isValid = listOfFavouriteMovieViewModel.textFieldIsEmpty(titleTextField: title, yearTextField: year)
        
        if isValid {
            if listOfFavouriteMovieViewModel.checkIfContains(name: title, year : year) {
                listOfFavouriteMovieViewModel.saveFav(name: titleTextField.text ?? "", year: year)
                listOfFavouriteMovieViewModel = fetchFav()
                reloadTableView()
                titleTextField.text = ""
                yearTextField.text = ""
            } else {
                AlertHelper.showAlert(presentingScreen: self, title: "IS ALREADY IN FAVOURITE LIST", message: "", actionTitle: "CANCEL") {
                    print("")
                }
            }
        } else {
            AlertHelper.showAlert(presentingScreen: self, title: "Text Fields cannot be empty or have to be valid year", message: "", actionTitle: "CANCEL") {
                print("")
            }
        }
    }
}


//MARK: - reload tableView
extension MainViewController {
    func reloadTableView() {
        tableView.beginUpdates()
        let rowIndex = listOfFavouriteMovieViewModel.numberOfRowInSection(0) - 1
        let indexPath: IndexPath = IndexPath(row: rowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}

//MARK: - Fetch from DB
extension MainViewController {
    
    func fetchFav() -> ListOfFavouriteMovieViewModel? {
        fav = realm.objects(FavouriteListModel.self)
        guard let favouriteMovie = fav else { fatalError() }
        listOfFavouriteMovieViewModel = ListOfFavouriteMovieViewModel(listOfFavouriteMoviewModel: favouriteMovie)
        return listOfFavouriteMovieViewModel
    }
    
}


//MARK: - UITextFieldDelegate (titleTextField - accepts just Strings, yearTextField - accepts just Integers)
extension MainViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == titleTextField {
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        } else {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as? FavCell else { fatalError(" fav movie cell not found") }
        let vm = listOfFavouriteMovieViewModel?.articleAtIndex(indexPath.row)
        guard let viewModel = vm else { fatalError() }
        let nameAndYearWithFonts = changeFont(title: viewModel.name, year: String(viewModel.year))
        cell.favMovieLabel.attributedText =  nameAndYearWithFonts
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfFavouriteMovieViewModel?.numberOfRowInSection(section) ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listOfFavouriteMovieViewModel?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let faMoviewList = fav else { fatalError() }
        if editingStyle == .delete {
            realm.beginWrite()
            realm.delete(faMoviewList[indexPath.row])
            try! realm.commitWrite()
         }
        self.tableView.deleteRows(at: [indexPath], with: .left)
    }
    
}
