//
//  Constants.swift
//  Kesley-Challenge-iOS-Agap2IT
//
//  Created by Kesley Ribeiro on 27/Dec/17.
//  Copyright © 2017 Kesley Ribeiro. All rights reserved.
//

import Foundation

// Declaring the BASE URL of API (to First View)
let BASE_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="

// Declaring the DETAIL BASE URL of API (to Second View)
let DETAIL_BASE_URL = "https://maps.googleapis.com/maps/api/place/details/json?placeid="

// API KEY
let API_KEY = "AIzaSyD5J_wtkXU2Z0Rc2Atm7UwLFKECDjl9-BU"

// OPTIONAL PARAMETER
let OPTIONAL_PARAMETER = "offset"

// VALUE OF THE PARAMETER
let VALUE_PARAMETER = "1"

// PLACE ID OF THE PLACE
var PLACE_ID = ""

// SEGUES
let TO_DETAILS = "toDetails"

// SAVE DETAILS INFO
var DETAILS_INFO_PLACE = ""
