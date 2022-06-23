//
//  AuthNavigationDelegate.swift
//  MyChat
//
//  Created by Дмитрий Писляков on 17.06.2022.
//

import Foundation

protocol AuthNavigationDelegate: AnyObject {
    func toLoginVC()
    func toSignUpVC()
}
