//
//  ChatVC.swift
//  Chat
//
//  Created by IMRAN on 20/04/21.
//

import UIKit

class ChatVC: UIViewController {
    
    @IBOutlet weak var tvMessages: UITableView!
    
    var userId : String?
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvMessages.delegate = self
        tvMessages.dataSource = self
        updateUI()
    }
    
    func updateUI(){
        let messagesViewModel = MessagesViewModel(userId: userId ?? "")
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
        let cell =  tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! ChatCell
        let message = messages[indexPath.item].message
        cell.chatMessage.text = "  \(message ?? "")  "
        cell.chatMessage.setRoundedCorner()
        return cell
    }
}
