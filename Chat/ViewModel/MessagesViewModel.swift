//
//  MessagesViewModel.swift
//  Chat
//
//  Created by VEENA on 20/04/21.
//

import UIKit

class MessagesViewModel: NSObject {
    private var apiService : APIService!
    var userId: String = ""
        private(set) var messagesData : Messages! {
            didSet {
                self.bindMessagesViewModelToController()
            }
        }
        
        var bindMessagesViewModelToController : (() -> ()) = {}
        
    
    init(userId: String) {
        super.init()
        apiService =  APIService()
        callFuncToGetUserMessages(userId: userId)
    }
        
    func callFuncToGetUserMessages(userId: String) {
            apiService.fetchChatMessagesFromBackend(userId: userId, completion: { [weak self] (messages) in
                if let self = self {
                    self.userId = userId
                    self.messagesData = messages
                    self.apiService = nil
                }
            })
        }
}
