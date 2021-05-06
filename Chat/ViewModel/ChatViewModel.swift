//
//  ChatViewModel.swift
//  Chat
//
//  Created by IMRAN on 27/04/21.
//

import UIKit

class ChatViewModel: NSObject {
    private var apiService : APIService!
        private(set) var isSent : String! {
            didSet {
                self.isChatSent()
            }
        }
        
        var isChatSent : (() -> ()) = {}
        
    init(userId: String, message: String, type: ChatType, files: [Media] = [], fileName: String = "") {
        super.init()
        apiService =  APIService()
        switch type {
            case .document:
                print("document message")
            case .media:
                callFuncToSendMediaMessage(userId: userId, message: message, files: files, fileName: fileName)
                
            case .text:
                callFuncToSendTextMessage(userId: userId, message: message)
            }
    }
        
    func callFuncToSendTextMessage(userId: String, message: String) {
        apiService.sendTextMessage(userId: userId, message: message) { (isChatSent) in
            if isChatSent {
                self.isSent = "Text chat successfully sent"
                self.apiService = nil
                }
            }
        }
    
    func callFuncToSendMediaMessage(userId: String, message: String, files: [Media], fileName: String){
        apiService.sendMediaMessage(userId: userId, message: message, files: files, fileName: fileName) { (isMediaSent) in
            if isMediaSent {
                self.isSent = "Media chat successfully sent"
                self.apiService = nil
            }
        }
    }

}
