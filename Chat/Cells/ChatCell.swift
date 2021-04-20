//
//  ChatCell.swift
//  Chat
//
//  Created by IMRAN on 20/04/21.
//

import UIKit

class ChatCell: UITableViewCell {
    
    
    @IBOutlet weak var chatMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
