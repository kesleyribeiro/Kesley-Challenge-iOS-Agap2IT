//
//  DetailsPlaceVC.swift
//  Kesley-Challenge-iOS-Agap2IT
//
//  Created by Kesley Ribeiro on 28/Dec/17.
//  Copyright © 2017 Kesley Ribeiro. All rights reserved.
//

import UIKit
import MapKit

class DetailsPlaceVC: UIViewController {

    // UI objs
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var mapPlace: MKMapView!
    
    // Code obj
    var allDetailsPlacesArray = [AnyObject]()
    var showAlerts = Alerts()

    // First load func
    override func viewDidLoad() {
        super.viewDidLoad()

        // Extras config label
        addressLbl.numberOfLines = 0
        addressLbl.lineBreakMode = .byWordWrapping
        addressLbl.sizeToFit() // Size to fit label
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Get details place according to place id
        getDetailsPlace(placeID: PLACE_ID)
    }
    
    // Function back button
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // Get detais place passing the place id
    func getDetailsPlace(placeID: String) {
        
        DataService.instance.getDetailsPlace(placeID: PLACE_ID) { (returnDetailsPlace) in
            
            switch returnDetailsPlace {
            case .success(let details):
                
                // Save details in allDetailsPlacesArray
                self.allDetailsPlacesArray = details as [AnyObject]
                
                let lat = self.allDetailsPlacesArray[1]
                let long = self.allDetailsPlacesArray[2]

                // Save address and show in the UI
                let address = self.allDetailsPlacesArray[0]
                self.addressLbl.text = address as? String
                
                self.openMapForPlace()

            case .error(let error):
                // Show the alert in the view
                self.showAlerts.exibirAlertaPersonalizado("There was an error while trying to get data! Try again!", tipoAlerta: 2)
                print("\nError: \(error)")
            }
        }
    }
    
    func openMapForPlace() {
        
        let lat = self.allDetailsPlacesArray[1]
        let long = self.allDetailsPlacesArray[2]
        
        print(lat, long)
        
        let location = CLLocationCoordinate2D(
            latitude: lat as! CLLocationDegrees,
            longitude: long as! CLLocationDegrees
        )
        
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapPlace.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location

        mapPlace.addAnnotation(annotation)
    }

}
