//
//  ViewController.swift
//  Chat
//
//  Created by IMRAN on 19/04/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tvChatFriendList: UITableView!
    @IBOutlet weak var imgbackground: UIImageView!
    
    var friendsList: [Friend] = []
    
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        tvChatFriendList.delegate = self
        tvChatFriendList.dataSource = self
        updateUI()
    }
    
    func updateUI(){
        self.view.showProgress(spinner: spinner)
        let friendsViewModel = FriendsViewModel()
        friendsViewModel.bindFriendViewModelToController = {
            self.friendsList = friendsViewModel.friendsData
            DispatchQueue.main.async {
                self.tvChatFriendList.reloadData()
                self.view.hideProgress(spinner: self.spinner)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.imgChatTick.isHidden = true
        cell.badgeView.isHidden = false
        cell.badgeView.maskCircle()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friendsList[indexPath.item]
        let chatVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.friendId = friend._id
        if let firstName = friend.firstName, let lastName = friend.lastName, let profilePic = friend.avatar{
            chatVC.friendName = "\(firstName) \(lastName)"
            chatVC.friendProfilePic = profilePic
        }
        self.navigationController?.pushViewController(chatVC, animated: false)
    }
}

