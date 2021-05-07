//
//  ChatCell.swift
//  Chat
//
//  Created by IMRAN on 20/04/21.
//

import UIKit

class ChatCell: UITableViewCell {
    
    
    @IBOutlet weak var chatMessage: UILabel!
    
    @IBOutlet weak var chatImage: UIImageView!
    
    @IBOutlet weak var timeStamp: UILabel!
    
    @IBOutlet weak var textOuterView: UIView!
    
    
    @IBOutlet weak var attachementCount: UILabel!
    
    @IBOutlet weak var countView: UIView!
    
    @IBOutlet weak var videoPlayerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
