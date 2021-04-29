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
    let message: String?
    let to: String?
    let from: String?
    let timestamp: String?
    let attachments: [String]
    let type: String?
}

typealias Messages = [Message]
