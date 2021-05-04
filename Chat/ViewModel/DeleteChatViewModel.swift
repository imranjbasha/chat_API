//
//  DeleteChatViewModel.swift
//  Chat
//
//  Created by IMRAN on 04/05/21.
//

import UIKit

class DeleteChatViewModel: NSObject {
    
    private var apiService : APIService!
        private(set) var deleteMessage : String! {
            didSet {
                self.isMessageDeleted()
            }
        }
    
    private(set) var clearedMessage : String! {
        didSet {
            self.isClearedAll()
        }
    }
        
        var isMessageDeleted : (() -> ()) = {}
    
        var isClearedAll : (() -> ()) = {}

        
    
    init(messageId: String, type: ChatDeleteType, userId: String) {
        super.init()
        apiService =  APIService()
        switch type {
        case .single:
            callFuncToDeleteMessage(userId: userId, messageId: messageId)
        case .all:
            callFuncToClearAllMessages(userId: userId)
        }
    }
        
    func callFuncToDeleteMessage(userId: String, messageId: String) {
        apiService.deleteMessage(messageId: messageId, userId: userId) { (isMessageDeleted) in
            if isMessageDeleted {
                self.deleteMessage = "Message deleted"
                self.apiService = nil
                }
            }
        }
    
    func callFuncToClearAllMessages(userId: String){
        apiService.clearAllMessages(userId: userId) { (isClearedAll) in
            if isClearedAll {
                self.clearedMessage = "Cleared messages"
                self.apiService = nil
                }
        }
    }

}
