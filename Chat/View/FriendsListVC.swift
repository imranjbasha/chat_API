//
//  ViewController.swift
//  Chat
//
//  Created by IMRAN on 19/04/21.
//

import UIKit

class FriendsListVC: UIViewController {

    @IBOutlet weak var tvChatFriendList: UITableView!
    @IBOutlet weak var imgbackground: UIImageView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    var friendsList: Friends = []
    
    var followers: [Friend] = []

    var following: [Friend] = []
    
    var friendsMessages: [String: [Message]] = [:]

    
    var spinner = UIActivityIndicatorView(style: .large)
    
    @IBAction func onTappedAdd(_ sender: UIButton) {
        if followers.count > 0 || following.count > 0 {
            let followersVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
            followersVC.followers = followers
            followersVC.followings = followers
            followersVC.friendsVC = self
            present(followersVC, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        tvChatFriendList.delegate = self
        tvChatFriendList.dataSource = self
        updateUI()
        fetchAndSaveFollow()
        self.addBtn.layer.shadowOpacity = 0.3
        self.addBtn.layer.shadowOffset = CGSize(width: 0, height: 15)
        self.addBtn.layer.shadowRadius = 5
    }
    
    func updateUI(){
        self.view.showProgress(spinner: spinner)
        let friendsViewModel = FriendsViewModel()
        friendsViewModel.bindFriendViewModelToController = {
            self.friendsList = friendsViewModel.friendsData
            let group = DispatchGroup()
                for friend in self.friendsList {
                    group.enter()
                    let messageVM = MessagesViewModel(userId: friend._id ?? "")
                    messageVM.bindMessagesViewModelToController = {
                        self.friendsMessages[messageVM.userId] = messageVM.messagesData
                        group.leave()
                    }
                }
            
            group.notify(queue: .main) {
                DispatchQueue.main.async {
                    self.tvChatFriendList.reloadData()
                    self.view.hideProgress(spinner: self.spinner)
                }
            }
        }
    }
    
    func fetchAndSaveFollow(){
        let friendsViewModel = FriendsViewModel()
        friendsViewModel.fetchedFollowers =  {
            self.addBtn.isHidden = false
            self.followers = friendsViewModel.followersData.followers
        }
        friendsViewModel.fetchedFollowing = {
            self.addBtn.isHidden = false
            self.following = friendsViewModel.followingData.following
        }
    }
    
    func onShownMessages(messages: [Message], userId: String){
        self.friendsMessages[userId] = messages
    }
    
    func onTappedChat(friend: Friend){
        let chatVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.friendId = friend._id
        let firstName = friend.firstName
        let lastName = friend.lastName
        let profilePic = friend.avatar
        chatVC.friendName = "\(firstName ?? "") \(lastName ?? "")"
        chatVC.friendProfilePic = profilePic ?? ""
        self.navigationController?.pushViewController(chatVC, animated: false)
    }
    
    func showClearAllAlert(friend: Friend){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteForMe = UIAlertAction(title: "Delete just for me", style: .destructive) { (action) in
            self.clearAll(shouldDeleteForBoth: false, friend: friend)
        }
        var userName: String = "this user"
        if let firstName = friend.firstName, let lastName = friend.lastName  {
            userName = "\(firstName) \(lastName)"
        }
        let deleteForAll = UIAlertAction(title: "Delete for me and \(userName)", style: .destructive) { (action) in
            self.clearAll(shouldDeleteForBoth: true, friend: friend)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.title = "Are you sure you want to delete the chat with \(userName) ?"
        alertController.addAction(deleteForMe)
        alertController.addAction(deleteForAll)
        alertController.addAction(cancel)
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func clearAll(shouldDeleteForBoth: Bool, friend: Friend){
        let deleteVM = DeleteChatViewModel(messageId: "", type: ChatDeleteType.all, userId: friend._id ?? "", shouldDeleteForBoth: shouldDeleteForBoth)
        deleteVM.isClearedAll = {
            self.updateUI()
        }
    }
}

extension FriendsListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! FriendListCell
        let friend = friendsList[indexPath.item]
        var image = UIImage(named: AssetsName.default_profile)
        if let imageUrlString = friend.avatar, let url = URL(string: imageUrlString), let data = try? Data(contentsOf: url) {
              image = UIImage(data: data)
        }
        cell.ivFriendProfile.maskCircle(image: image!)
        cell.friendName.text = "\(friend.firstName ?? "") \(friend.lastName ?? "")"
        let messages = self.friendsMessages[friend._id ?? ""] ?? []
        if messages.count > 0 {
            let lastMessage = messages[messages.count-1]
            if lastMessage.to == friend._id {
                cell.imgChatTick.isHidden = false
                cell.timeStamp.isHidden = false
                cell.timeStamp.text = UtilsClass.convertUTCtoLocal(date: lastMessage.timestamp ?? "")
            }else {
                var badgeCount: Int = 0
                for message in messages.reversed() {
                    if message.to != friend._id && !message.hasSeen {
                        badgeCount = badgeCount+1
                    }
                }
                if badgeCount > 0 {
                    cell.badgeView.isHidden = false
                    cell.badgeView.maskCircle()
                    cell.badgeCount.text = "\(badgeCount)"
                    cell.timeStamp.isHidden = false
                    cell.timeStamp.text = UtilsClass.convertUTCtoLocal(date: lastMessage.timestamp ?? "")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friendsList[indexPath.item]
        let chatVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.friendId = friend._id
        let firstName = friend.firstName
        let lastName = friend.lastName
        let profilePic = friend.avatar
        chatVC.friendName = "\(firstName ?? "") \(lastName ?? "")"
        chatVC.friendProfilePic = profilePic ?? ""
        if self.friendsMessages.count == self.friendsList.count {
            chatVC.messages = self.friendsMessages[friend._id ?? ""] ?? []
            chatVC.friendsVC = self
        }
        self.navigationController?.pushViewController(chatVC, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let friend = friendsList[indexPath.item]
            showClearAllAlert(friend: friend)
        }
    }
}

