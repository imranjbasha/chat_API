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
    
    var fullList: [Friend] = []
    
    var friendsVC :FriendsListVC?

    
    @IBAction func onTappedClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tvFollowers.delegate = self
        self.tvFollowers.dataSource = self
        if followers.count > 0 || followings.count > 0 {
            fullList.append(contentsOf: followers)
            for item in followings {
                if !fullList.contains(where: { (friend) -> Bool in
                    if friend._id == item._id {
                        return true
                    }else {
                        return false
                    }
                }){
                    fullList.append(item)
                }
            }
            self.tvFollowers.reloadData()
        }
    }
    
    
    @objc func chatButtonPressed(_sender: UIButton)
    {
        self.dismiss(animated: false) {
            let index = _sender.tag
            if self.fullList.count > index {
                self.friendsVC?.onTappedChat(friend: self.fullList[index])
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! FriendListCell
        let friend = fullList[indexPath.item]
        var image = UIImage(named: AssetsName.default_profile)
        if let imageUrlString = friend.avatar, let url = URL(string: imageUrlString), let data = try? Data(contentsOf: url) {
              image = UIImage(data: data)
        }
        cell.ivFriendProfile.maskCircle(image: image!)
        cell.friendName.text = "\(friend.firstName ?? "") \(friend.lastName ?? "")"
        cell.chatRequestBtn.roundedButton()
        cell.chatBtn.tag = indexPath.row
        cell.chatBtn.addTarget(self, action: #selector(FollowersVC.chatButtonPressed), for: .touchUpInside)
        return cell
    }
    
    
}
