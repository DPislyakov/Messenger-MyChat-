//
//  UILabel + Extension.swift
//  MyChat
//
//  Created by Дмитрий Писляков on 10.06.2022.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
    
        self.text = text
        self.font = font
    }
}
