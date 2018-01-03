//
//  PlaceVC.swift
//  Kesley-Challenge-iOS-Agap2IT
//
//  Created by Kesley Ribeiro on 28/Dec/17.
//  Copyright © 2017 Kesley Ribeiro. All rights reserved.
//

import UIKit

class PlaceVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // UI objs
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var placeTblView: UITableView!
    @IBOutlet weak var noResultLbl: UILabel!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!

    // Code obj
    var allPlacesArray = [AnyObject]()
    var showAlerts = Alerts()

    // First load func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call function
        startUI()
        
        // This code withdrawn in: https://stackoverflow.com/questions/24529373/tableview-scroll-content-when-keyboard-shows
        // Called when keyboard is show
        NotificationCenter.default.addObserver(self, selector: #selector(PlaceVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        // This code withdrawn in: https://stackoverflow.com/questions/24529373/tableview-scroll-content-when-keyboard-shows
        // Called when keyboard is hide
        NotificationCenter.default.addObserver(self, selector: #selector(PlaceVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    // Delete the place id value whenever the view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        PLACE_ID.removeAll()
    }

    func startUI() {
        // Start activity indicator
        myActivityIndicator.startAnimating()
        
        // Creating connections to access protocols of DataSource and Delegate
        placeTblView.dataSource = self
        placeTblView.delegate = self
        
        // Config the row height in the table view and auto dimension when necessary
        placeTblView.estimatedRowHeight = 50
        placeTblView.rowHeight = UITableViewAutomaticDimension
        
        // Start with table view hidden because it does not have any search results
        placeTblView.isHidden = true
    }

    // This method withdrawn in: https://stackoverflow.com/questions/24529373/tableview-scroll-content-when-keyboard-shows
    // Adjust table view according to keyboard
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            placeTblView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        }
    }

    // This method withdrawn in: https://stackoverflow.com/questions/24529373/tableview-scroll-content-when-keyboard-shows
    // Adjust table view according to keyboard
    @objc func keyboardWillHide(_ notification:Notification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            placeTblView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }

    // Get place info passing the entered text
    func getPlace(textEnteredByUser: String) {

        DataService.instance.getInfoPlace(textEnteredByUser: textEnteredByUser) { (returnPlace) in

            switch returnPlace {
            case .success(let places):
                
                // Save the data in allPlacesArray
                self.allPlacesArray = places
                
                self.cofigShowTblView()
                
                // Update the data in table view
                self.placeTblView.reloadData()

            case .error(let error):
                // Show the alert in the view
                self.showAlerts.exibirAlertaPersonalizado("There was an error while trying to get data! Try again!", tipoAlerta: 2)
                print("\nError: \(error)")
            }
        }
    }

    // MARK: - Table view data source
    
    // Number of the cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlacesArray.count
    }

    // Config of the prototype cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Creating a constant to access a cell of the tableView
        let cell = placeTblView.dequeueReusableCell(withIdentifier: "cell") as! PlaceCell
        
        // Get description of the place
        if let description_place = allPlacesArray[indexPath.row]["description"] {
            cell.descriptionPlaceLbl.text = description_place as? String
        }
        return cell
    }
    
    /* Get the place_id according to the index of the selected cell.
        This data is used as parameter to try to get the place details
        and show the infos in the next view (DetailsPlaceVC)
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let place_id = allPlacesArray[indexPath.row]["place_id"] {
            PLACE_ID = (place_id as? String)!
        }
        // Deselect row according the index of the cell
        placeTblView.deselectRow(at: indexPath, animated: true)
        
        // Call the next view (DetailsPlaceVC)
        performSegue(withIdentifier: TO_DETAILS, sender: (indexPath.row))
    }

    // Firstly executed func when user tapped a searchBar
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        // Show *Cancel button in searchBar
        searchBar.setShowsCancelButton(true, animated: true)

        return true
    }

    // Called when *Cancel of SearchBar is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // Hide *Cancel button in searchBar
        searchBar.setShowsCancelButton(false, animated: true)
        
        // Clean text
        searchBar.text = ""
        
        // Hide the keyboard
        searchBar.endEditing(true)
        
        // Remove all data in the placesArray (= 0)
        allPlacesArray.removeAll()

        // Call function
        cofigHideTblView()
    }
    
    // Called when button "Search" or "Buscar" is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTheText(searchBar)
    }
    
    // Called when some text in searchBar got changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTheText(searchBar)
    }
    
    // Get and organize the entered text
    func searchTheText(_ searchBar: UISearchBar) {

        // Check if text is empty
        if (searchBar.text?.isEmpty)! {

            cofigHideTblView()
            
        } // Text entered - no empty
        else {
            
            // Call function
            cofigShowTblView()

            // Save in the var the text entered by the user
            let textEnteredByUser = searchBar.text!
            
            // Removes accentuation
            let textWithoutAccent = textEnteredByUser.folding(options: .diacriticInsensitive, locale: .current)
            
            // Removes spaces to concatenate the string
            let textWithoutSpace = textWithoutAccent.replacingOccurrences(of: " ", with: "")
            
            // Send the correct text to request data of API
            getPlace(textEnteredByUser: textWithoutSpace)
        }

        // Update the data in table view
        placeTblView.reloadData()
    }
    
    // Config used when is necessary show the tableView, hide the noResult label and stop animation
    func cofigShowTblView() {

        // Show the table view
        placeTblView.isHidden = false
        
        // Hide the noResult label
        noResultLbl.isHidden = true
        
        // Stop activity indicator animation
        myActivityIndicator.stopAnimating()
    }
    
    // Config used when is necessary hide he tableView, show the noResult label and start animation
    func cofigHideTblView() {

        // Hide the table view
        placeTblView.isHidden = true
        
        // Show the label
        noResultLbl.isHidden = false
        
        // Start activity indicator
        myActivityIndicator.startAnimating()
    }

    // Hide the keyboard and *Cancel button when user touch the view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Hide the *Cancel button
        searchBar.setShowsCancelButton(false, animated: true)

        // Hide the keyboard
        self.view.endEditing(true)
    }

}

