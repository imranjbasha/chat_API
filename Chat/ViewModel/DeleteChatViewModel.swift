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

        
    
    init(messageId: String, type: ChatDeleteType, userId: String, shouldDeleteForBoth: Bool) {
        super.init()
        apiService =  APIService()
        switch type {
        case .single:
            callFuncToDeleteMessage(userId: userId, messageId: messageId, shouldDeleteForBoth: shouldDeleteForBoth)
        case .all:
            callFuncToClearAllMessages(userId: userId, shouldDeleteForBoth: shouldDeleteForBoth)
        }
    }
        
    func callFuncToDeleteMessage(userId: String, messageId: String, shouldDeleteForBoth: Bool) {
        apiService.deleteMessage(messageId: messageId, userId: userId, shouldDeleteForBoth: shouldDeleteForBoth) { (isMessageDeleted) in
            if isMessageDeleted {
                self.deleteMessage = "Message deleted"
                self.apiService = nil
                }
            }
        }
    
    func callFuncToClearAllMessages(userId: String, shouldDeleteForBoth: Bool){
        apiService.clearAllMessages(userId: userId, shouldDeleteForBoth: shouldDeleteForBoth) { (isClearedAll) in
            if isClearedAll {
                self.clearedMessage = "Cleared messages"
                self.apiService = nil
                }
        }
    }

}
