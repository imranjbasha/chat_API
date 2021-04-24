//
//  ChatVC.swift
//  Chat
//
//  Created by IMRAN on 20/04/21.
//

import UIKit

class ChatVC: UIViewController {
    
    @IBOutlet weak var tvMessages: UITableView!
    
    
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var chatInputView: UIView!
    
    var friendId : String?
    
    var friendName : String?
    
    var friendProfilePic : String?

    
    var messages: [Message] = []
    
    @IBOutlet weak var tfChat: UITextField!
    
    @IBOutlet weak var chatSendBtn: UIButton!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userProfilePic: UIImageView!
    
    @IBAction func onTappedButtons(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            print("Tapped send")
        case 2:
            self.navigationController?.popToRootViewController(animated: true)
        case 3:
            print("Tapped search")
        default:
            print("default")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        updateUI()
        loadChatList()
    }
    
    func updateUI(){
        imgBackground.setCornerRadius(value: 50.0)
        chatSendBtn.roundedButton()
        tvMessages.delegate = self
        tvMessages.dataSource = self
        chatInputView.setCornerRadius(value: 25.0)
        chatInputView.setBorder(color: UIColor.gray, width: 1.0)
        if let friendName = friendName, let friendProfilePic = friendProfilePic, let url = URL(string: friendProfilePic), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            self.userName.text = friendName
            self.userProfilePic.maskCircle(image: image)
        }
    }
    
    func loadChatList(){
        let messagesViewModel = MessagesViewModel(userId: friendId ?? "")
        messagesViewModel.bindMessagesViewModelToController = {
            self.messages = messagesViewModel.messagesData
            DispatchQueue.main.async {
                self.tvMessages.reloadData()
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


extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageData = messages[indexPath.item]
        if messageData.to == friendId {
            if messageData.type == "media" || messageData.type == "document" {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "FriendImageCell", for: indexPath) as! ChatCell
                let image = messageData.attachments
                if image.count > 0 , let url = URL(string: image[0]), let data = try? Data(contentsOf: url) {
                    cell.chatImage.image = UIImage(data: data)
                }else{
                    cell.chatImage.image = UIImage(named: AssetsName.icon_default_chat_image)
                }
                cell.chatImage.setCorner(value: 20.0)
                return cell
            }else{
                let cell =  tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! ChatCell
                let message = messageData.message
                cell.chatMessage.text = "  \(message ?? "")  "
                cell.chatMessage.setRoundedCorner()
                return cell
            }
        }else{
            let cell =  tableView.dequeueReusableCell(withIdentifier: "OwnCell", for: indexPath) as! ChatCell
            let message = messageData.message
            cell.chatMessage.text = "  \(message ?? "")  "
            cell.chatMessage.setRoundedCorner()
            return cell
        }
    }
}
