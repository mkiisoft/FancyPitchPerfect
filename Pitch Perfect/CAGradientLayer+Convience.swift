//
//  CAGradientLayer+Convience.swift
//  Pitch Perfect
//
//  Created by Mariano Zorrilla on 10/14/15.
//  Copyright © 2015 MkiiSoft. All rights reserved.
//

import UIKit

extension CAGradientLayer {

    func turquoiseColor() -> CAGradientLayer {
        
        let topColor = UIColor(red: (15/255.0), green: (118/255.0), blue: (128/255.0), alpha: 1)
        let bottomColor = UIColor(red: (84/255.0), green: (187/255.0), blue: (187/255.0), alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocalization: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocalization
        
        return gradientLayer
        
    }
}
