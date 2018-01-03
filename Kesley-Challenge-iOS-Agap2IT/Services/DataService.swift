//
//  DataService.swift
//  Kesley-Challenge-iOS-Agap2IT
//
//  Created by Kesley Ribeiro on 27/Dec/17.
//  Copyright © 2017 Kesley Ribeiro. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}

struct Location {
    
    var addss: String
    var lat: String
    var long: String
    
    init(adds: String, lat: String, long: String) {
        self.addss = adds
        self.lat = lat
        self.long = long
    }
    
}

typealias ReturnInfoPlace = (Result<[AnyObject]>) -> Void
typealias ReturnInfoDetailsPlace = (Result<Location>) -> Void

protocol DataServiceDelegate: class {
    
    func getInfoPlace()
    func getDetailsPlace()
}

class DataService {
    
    var showAlerts = Alerts()
    
    static let instance = DataService()
    
    weak var delegate: DataServiceDelegate?
    
    // Get info place
    func getInfoPlace(textEnteredByUser: String, completion: @escaping ReturnInfoPlace) {
        
        // Declaring URL of json
        let URL = NSURL(string: "\(BASE_URL)\(textEnteredByUser)&\(OPTIONAL_PARAMETER)=\(VALUE_PARAMETER)&key=\(API_KEY)")!
        
        // Declaring request of URL
        let request = NSMutableURLRequest(url: URL as URL)
        
        // Executing request
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            // Error
            if error != nil {
                // Show the alert in the view
                self.showAlerts.exibirAlertaPersonalizado("There was an error while trying to request data! Try again!", tipoAlerta: 2)
                print("\nError while trying request: \(String(describing: error))")
                completion(.error(error!))
            }
            
            // Use the main queue to exec
            DispatchQueue.main.sync {
                
                // Get JSON Data
                do {
                    
                    // Declaring new var to store JSON Data
                    let JSON_DATA = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    // Secure way to declare new var that will store JSON Data
                    guard let parsedJSON = JSON_DATA else {
                        
                        // Show the alert in the view
                        self.showAlerts.exibirAlertaPersonalizado("There was an error while trying to get data! Try again!", tipoAlerta: 2)
                        print("\nError while try to get data!")
                        
                        return
                    }
                    
                    // Secure way to declare new var that will store JSON Data
                    guard let placesJSON = parsedJSON["predictions"] else {
                        
                        // Show the alert in the view
                        self.showAlerts.exibirAlertaPersonalizado("There was an error while trying to get predictions data! Try again!", tipoAlerta: 2)
                        print("\nError while try to get data predictions")
                        
                        return
                    }

                    completion(.success(placesJSON as! [AnyObject]))
                    
                } catch {
                    print("\nError: \(error)")
                    
                    // Show the alert in the view
                    self.showAlerts.exibirAlertaPersonalizado("There was an error while trying to get data! Try again!", tipoAlerta: 2)
                    completion(.error(error))
                }
            }
        }.resume()
    }
    
    // Get info details place
    func getDetailsPlace(placeID: String, completion: @escaping ReturnInfoDetailsPlace) {
        
        var addss: String = ""
        var lat: String = ""
        var long: String = ""
        
        // Declaring URL of json
        let URL = NSURL(string: "\(DETAIL_BASE_URL)\(placeID)&key=\(API_KEY)")!
        
        // Declaring request of URL
        let request = NSMutableURLRequest(url: URL as URL)
        
        // Executing request
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            // Error
            if error != nil {
                // Show the alert in the view
                self.showAlerts.exibirAlertaPersonalizado("There was an error while trying to request data! Try again!", tipoAlerta: 2)
                print("\nError while trying request: \(String(describing: error))")
            }
            
            // Use the main queue to exec
            DispatchQueue.main.sync {
                
                // Get JSON Data
                do {
                    
                    // Declaring new var to store JSON Data
                    let JSON_DATA = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    
                    guard let json = JSON_DATA as? [String: Any] else { return }
                    
                    if let result = json["result"] as? [String:Any] {
                        
                        // Get address place
                        if let address = result["formatted_address"] as? String {
                            addss = address
                        } else {
                            // Show the alert in the view
                            self.showAlerts.exibirAlertaPersonalizado("There was an error while trying to get address! Try again!", tipoAlerta: 2)
                        }
                        
                        if let geometry = result["geometry"] as? [String:Any] {
                            if let location = geometry["location"] as? [String:Any] {
                                
                                // Get latitude place
                                guard let latitude = location["lat"] else {
                                    
                                    // Show the alert in the view
                                    self.showAlerts.exibirAlertaPersonalizado("There was an error while trying to get latitude! Try again!", tipoAlerta: 2)
                                    print("\nError while try to get latitude")
                                    return
                                }
                                lat = String(describing: latitude)
                                
                                // Get longitude place
                                guard let longitude = location["lng"] else {
                                    
                                    // Show the alert in the view
                                    self.showAlerts.exibirAlertaPersonalizado("There was an error while trying to get longitude! Try again!", tipoAlerta: 2)
                                    print("\nError while try to get longitude")
                                    return
                                }
                                long = String(describing: longitude)
                            }
                        }
                        let location = Location(adds: addss, lat: lat, long: long)
                        completion(.success(location))
                    }
                }
                catch {
                    // Show the alert in the view
                    self.showAlerts.exibirAlertaPersonalizado("There was an error while trying to request data! Try again!", tipoAlerta: 2)
                    print("\nError while trying request: \(String(describing: error))")
                }
            }
        }.resume()
    }
    
}
