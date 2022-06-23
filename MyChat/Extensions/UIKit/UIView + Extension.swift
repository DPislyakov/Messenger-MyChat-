//
//  UIView + Extension.swift
//  MyChat
//
//  Created by Дмитрий Писляков on 16.06.2022.
//

import UIKit

extension UIView {
    
    func applyGradients(cornerRadius: CGFloat) {
        let startColor = UIColor(red: 235/255, green: 188/255, blue: 245/255, alpha: 1)
        let endColor = UIColor(red: 152/255, green: 156/255, blue: 227/255, alpha: 1)
        self.backgroundColor = nil
        self.layoutIfNeeded()
        
        let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: startColor, endColor: endColor)
        
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
