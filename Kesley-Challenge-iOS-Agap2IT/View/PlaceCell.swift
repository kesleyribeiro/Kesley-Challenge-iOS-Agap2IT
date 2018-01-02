//
//  PlaceCell.swift
//  Kesley-Challenge-iOS-Agap2IT
//
//  Created by Kesley Ribeiro on 28/Dec/17.
//  Copyright © 2017 Kesley Ribeiro. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {

    // UI objs
    @IBOutlet weak var descriptionPlaceLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Config the label "descriptionPlace"
        descriptionPlaceLbl.numberOfLines = 0
        descriptionPlaceLbl.lineBreakMode = .byWordWrapping
        descriptionPlaceLbl.sizeToFit()
    }
    
}
