//
//  WaitingChatsNavigation.swift
//  MyChat
//
//  Created by Дмитрий Писляков on 22.06.2022.
//

import Foundation

protocol WaitingChatsNavigation: AnyObject {
    
    func removeWaitingChat(chat: MChat)
    func changeToActiv(chat: MChat)
}
