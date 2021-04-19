//
//  Chat.swift
//  Chat
//
//  Created by IMRAN on 19/04/21.
//

import Foundation

struct Friend: Codable {
    let id: String?
    let firstName: String?
    let lastName: String?
}

typealias Friends = [Friend]

