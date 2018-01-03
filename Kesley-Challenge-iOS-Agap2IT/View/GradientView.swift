//
//  GradientView.swift
//  Kesley-Challenge-iOS-Agap2IT
//
//  Created by Kesley Ribeiro on 02/Jan/18.
//  Copyright © 2018 Kesley Ribeiro. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0, green: 0.6470588235, blue: 0.6666666667, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }

    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0, green: 0.3415256076, blue: 0.8943684896, alpha: 1)  {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        
        let gradienteLayer = CAGradientLayer()
        
        gradienteLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradienteLayer.startPoint = CGPoint(x: 0, y: 0)
        gradienteLayer.endPoint = CGPoint(x: 1, y: 1)
        gradienteLayer.frame = self.bounds

        self.layer.insertSublayer(gradienteLayer, at: 0)
    }
    
}
