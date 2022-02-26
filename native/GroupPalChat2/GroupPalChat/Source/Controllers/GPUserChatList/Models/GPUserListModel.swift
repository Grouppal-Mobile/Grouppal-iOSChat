//
//  GPUserListModel.swift
//  GroupPalChat
//
//  Created by Aravind on 23/02/22.
//

import Foundation

// MARK: - MessagesCodable
struct GPUserListsCodable: Codable {
    let result: Bool?
    let msg: String?
    var data: [GPUserCodable]?
}

// MARK: - Datum
struct GPUserCodable: Codable {
    let id: Int?
    let merchantID: String?
    let image: String?
    var name, lastMessage: String?
    let time, messageTypeID, unreadCount: Int?
    let onlineStatue: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case merchantID = "merchant_id"
        case image, name
        case lastMessage = "last_message"
        case time
        case messageTypeID = "message_type_id"
        case unreadCount = "unread_count"
        case onlineStatue = "online_statue"
    }
}
