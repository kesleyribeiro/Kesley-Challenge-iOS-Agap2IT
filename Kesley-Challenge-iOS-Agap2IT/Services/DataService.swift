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

typealias ReturnInfoPlace = (Result<[AnyObject]>) -> Void
typealias ReturnInfoDetailsPlace = (Result<[String]>) -> Void

protocol DataServiceDelegate: class {

    func getInfoPlace()
    func getDetailsPlace()
}

class DataService {

    static let instance = DataService()

    weak var delegate: DataServiceDelegate?

    // Get info place
    func getInfoPlace(textEnteredByUser: String, completion: @escaping ReturnInfoPlace) {

        // Declaring URL of json
        let URL = NSURL(string: "\(BASE_URL)\(textEnteredByUser)&\(OPTIONAL_PARAMETER)=\(VALUE_PARAMETER)&key=\(API_KEY)")!
        
        // Declaring request of URL
        let request = NSMutableURLRequest(url: URL as URL)
        
        // Executing request
        URLSession.shared.dataTask(with: request as URLRequest) { (data:Data?, response:URLResponse?, error:Error?) in
            
            // Error
            if error != nil {
                print("\nError while try request: \(String(describing: error))")
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
                        print("\nError while try to get data!")
                        return
                    }

                    // Secure way to declare new var that will store JSON Data
                    guard let placesJSON = parsedJSON["predictions"] else {
                        print("\nError while try to get data predictions")
                        return
                    }
                    
                    completion(.success(placesJSON as! [AnyObject]))
                    
                } catch {
                    print("\nError: \(error)")
                    completion(.error(error))
                }
            }
        }.resume()
    }
    
    // Get info details place
    func getDetailsPlace() {
        
        // Declaring URL of json
        let URL = NSURL(string: "\(DETAIL_BASE_URL)\(PLACE_ID)&key=\(API_KEY)")!
        
        // Declaring request of URL
        let request = NSMutableURLRequest(url: URL as URL)
        
        // Executing request
        URLSession.shared.dataTask(with: request as URLRequest) { (data:Data?, response:URLResponse?, error:Error?) in
            
            // Error
            if error != nil {
                print("\nError while try request: \(String(describing: error))")
            }
            
            // Use the main queue to exec
            DispatchQueue.main.sync {
                
                // Get JSON Data
                do {
                    // Declaring new var to store JSON Data
                    let JSON_DATA = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)

                    guard let json = JSON_DATA as? [String: Any] else { return }

                    if let result = json["result"] {
                        print("\nResult: \(result)")
                    } else {
                        print("\nErro!!!")
                    }
                    
                } catch {
                    print("\nError: \(error)")
                }
            }
        }.resume()
    }

}

