//
//  GPConversationCodables.swift
//  GroupPalChat
//
//  Created by Aravind on 23/02/22.
//

import Foundation
import UIKit

// MARK: - MessagesCodable
struct MessagesCodable: Codable {
    let result: Bool?
    let msg: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let profileDetails: ProfileDetails?
    let messages: [DataCodable]?

    enum CodingKeys: String, CodingKey {
        case profileDetails = "profile_details"
        case messages
    }
}

// MARK: - Message
struct DataCodable: Codable {
    let senderID: String?
    let receiverID: String?
    let message: String?
    let messageTypeID, messageDate, msgStatus: Int?
    let message_id: Int?

    enum CodingKeys: String, CodingKey {
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case message
        case messageTypeID = "message_type_id"
        case messageDate = "message_date"
        case msgStatus = "msg_status"
        case message_id
    }
}

// MARK: - ProfileDetails
struct ProfileDetails: Codable {
    let merchantName: String?
    let merchantIcon: String?
    let onlineStatus: Bool?
    let block_status: Int?

    enum CodingKeys: String, CodingKey {
        case merchantName = "merchant_name"
        case merchantIcon = "merchant_icon"
        case onlineStatus = "online_status"
        case block_status
    }
}


