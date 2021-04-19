//
//  FriendsViewModel.swift
//  Chat
//
//  Created by IMRAN on 19/04/21.
//

import UIKit

class FriendsViewModel: NSObject {
    
    private var apiService : APIService!
        private(set) var friendsData : Friends! {
            didSet {
                self.bindFriendViewModelToController()
            }
        }
        
        var bindFriendViewModelToController : (() -> ()) = {}
        
        override init() {
            super.init()
            apiService =  APIService()
            callFuncToGetFriendsData()
        }
        
        func callFuncToGetFriendsData() {
            apiService.fetchFriendsListFromBackend(completion: { [weak self] (friendsData) in
                if let self = self,  friendsData.count > 0 {
                    self.friendsData = friendsData
                    self.apiService = nil
                }
            })
        }

}
