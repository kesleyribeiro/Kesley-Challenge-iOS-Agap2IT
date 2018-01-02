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

    // First load func
    override func viewDidLoad() {
        super.viewDidLoad()

        // Extras config label
        addressLbl.numberOfLines = 0
        addressLbl.lineBreakMode = .byWordWrapping
        addressLbl.sizeToFit()
        
        //mapPlace.addAnnotation(<#T##annotation: MKAnnotation##MKAnnotation#>)
        //centerMapOnLocation(CLLocation(latitude: details!.lat, longitude: details!.long))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("\n\nPLACE ID: \(PLACE_ID)")
        DataService.instance.getDetailsPlace()
    }
    
    // Function back button
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
/*
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(details!.coordinate, 1000, 1000)

        mapPlace.setRegion(coordinateRegion, animated: true)
    }
*/
/*
    // Get details place passing place id
    func getDetailsPlace(placeID: String) {

        // Save the details in detailsPlaceArray
        let detailsPlaceArray = DataService.instance.getDetailsPlace()
    }
*/
}
