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
    
    private(set) var followersData : Followers! {
        didSet {
            self.fetchedFollowers()
        }
    }
    
    private(set) var followingData : Followings! {
        didSet {
            self.fetchedFollowing()
        }
    }
        
        var bindFriendViewModelToController : (() -> ()) = {}
   
        var fetchedFollowers : (() -> ()) = {}

        var fetchedFollowing : (() -> ()) = {}

        
        override init() {
            super.init()
            apiService =  APIService()
            callFuncToGetFriendsData()
            callFuncToGetFollowers()
            callFuncToGetFollowing()
        }
        
        func callFuncToGetFriendsData() {
            apiService.fetchFriendsListFromBackend(completion: { [weak self] (friendsData) in
                if let self = self,  friendsData.count > 0 {
                    self.friendsData = friendsData
                    self.apiService = nil
                }
            })
        }
    
    func callFuncToGetFollowers() {
        apiService.fetchFollowers(completion: { [weak self] (followersData) in
            if let self = self,  followersData.followers.count > 0 {
                self.followersData = followersData
                self.apiService = nil
            }
        })
    }
    func callFuncToGetFollowing() {
        apiService.fetchFollowings(completion: { [weak self] (followingData) in
            if let self = self,  followingData.following.count > 0 {
                self.followingData = followingData
                self.apiService = nil
            }
        })
    }


}
