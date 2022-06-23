//
//  SelfConfiguringCell.swift
//  MyChat
//
//  Created by Дмитрий Писляков on 16.06.2022.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure<U: Hashable>(with value: U)
}
