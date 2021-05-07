//
//  FollowersVC.swift
//  Chat
//
//  Created by VEENA on 29/04/21.
//

import UIKit

class FollowersVC: UIViewController {
    
    
    @IBOutlet weak var tvFollowers: UITableView!
    
    var followers: [Friend] = []
    
    var followings: [Friend] = []
    
    var fullList: [Follow] = []
    
    var friendsVC :FriendsListVC?
    
    
    @IBAction func onTappedClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tvFollowers.delegate = self
        self.tvFollowers.dataSource = self
        if followers.count > 0 || followings.count > 0 {
            self.fullList.append(Follow(users: followers, isOpened: false, title: "Followers"))
            self.fullList.append(Follow(users: followers, isOpened: false, title: "Followings"))
        }
    }
    
    
    @objc func chatButtonPressed(_sender: CustomTapGestureRecognizer)
    {
        self.dismiss(animated: false) {
            if let friend = _sender.friend {
                self.friendsVC?.onTappedChat(friend: friend)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FollowersVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        fullList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = fullList[section]
        if section.isOpened {
            return section.users.count + 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! FriendListCell
            let section = fullList[indexPath.section]
            cell.headerTitle.text = section.title
            cell.headerView.setBorder(color: UIColor.gray, width: 1.5)
            return cell
        }else{
            let cell =  tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! FriendListCell
            let section = fullList[indexPath.section]
            let friend = section.users[indexPath.row - 1]
            var image = UIImage(named: AssetsName.default_profile)
            if let imageUrlString = friend.avatar, let url = URL(string: imageUrlString), let data = try? Data(contentsOf: url) {
                  image = UIImage(data: data)
            }
            cell.ivFriendProfile.maskCircle(image: image!)
            cell.friendName.text = "\(friend.firstName ?? "") \(friend.lastName ?? "")"
            cell.followFriendView.setCornerRadius(value: 15.0)
            cell.followFriendView.setBorder(color: .lightGray, width: 1.0)
            cell.chatRequestBtn.roundedButton()
            let tapGesture = CustomTapGestureRecognizer(target: self, action: #selector(FollowersVC.chatButtonPressed))
            tapGesture.friend = friend
            cell.chatBtn.addGestureRecognizer(tapGesture)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            fullList[indexPath.section].isOpened = !fullList[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }
}

class CustomTapGestureRecognizer: UITapGestureRecognizer {
    var friend: Friend? = nil
}
