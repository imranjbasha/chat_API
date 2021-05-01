//
//  FriendListCell.swift
//  Chat
//
//  Created by IMRAN on 19/04/21.
//

import UIKit

class FriendListCell: UITableViewCell {
    
    
    @IBOutlet weak var ivFriendProfile: UIImageView!
    
    @IBOutlet weak var friendName: UILabel!
        
    @IBOutlet weak var timeStamp: UILabel!
    
    @IBOutlet weak var imgChatTick: UIImageView!
    
    @IBOutlet weak var badgeView: UIView!
    
    @IBOutlet weak var badgeCount: UILabel!
    
    @IBOutlet weak var chatRequestBtn: UIButton!
    
    @IBOutlet weak var chatBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
