//
//  Chat.swift
//  Chat
//
//  Created by IMRAN on 19/04/21.
//

import Foundation

struct Friend: Codable {
    let _id: String?
    let firstName: String?
    let lastName: String?
    let avatar: String?
}

typealias Friends = [Friend]

struct Followers: Codable {
    let followers: [Friend]
}

struct Followings: Codable {
    let following: [Friend]
}
struct Message: Codable {
    let _id: String?
    let message: String?
    let to: String?
    let from: String?
    let timestamp: String?
    let attachments: [String]
    let type: String?
    let hasSeen: Bool
}

typealias Messages = [Message]

class Follow {
    let users: [Friend]
    var isOpened: Bool = false
    var title: String = ""

    init(users: [Friend], isOpened: Bool, title: String) {
        self.users = users
        self.isOpened = isOpened
        self.title = title
    }
}
