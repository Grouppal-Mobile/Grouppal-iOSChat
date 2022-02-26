//
//  GPConversationModel.swift
//  GroupPalChat
//
//  Created by Aravind on 23/02/22.
//

import Foundation
import UIKit

protocol GPConversationListInteractorDataSource {
    func triggerInitialMessages()
    func triggerPaginationAPI(page: Int)
    func triggerSendMessageAPI(message: Message , index: IndexPath)
    func triggerBlockAPI(isBlocked: Bool)
    func triggerDeleteAPI(messages: [Message])
}

protocol GPConversationInteractorDelegates {
    func didInitalMessagesCompleted(messages: [Message], isBlocked: Bool)
    func didPaginationMessagesCompleted(messages: [Message] , page: Int)
    func triggerSendMessageAPICompelted(index: IndexPath , status: Bool, message: Message)
    func triggerBlockAPICompleted()
}

protocol Message {
    var message_id: String? { get set }
    var direction: MessageDirection { get set }
    var type: MessageType { get set }
    var time: String { get set }
    var date: String { get set }
    var status: MessageReadStatus { get set }
    var imageURL: String? { get set }
    var content: String? { get set }
    var isSelectedforDelete: Bool { get set }
}

enum MessageReadStatus {
    case singleTick
    case doubleTick
    case readed
}

enum MessageType {
    case text
    case image
}

enum MessageDirection {
    case from
    case to
}

 
class MessageDataModel: Message {
    
    var direction: MessageDirection
    
    var type: MessageType
    
    var time: String
    
    var date: String
    
    var status: MessageReadStatus
    
    var imageURL: String?
    
    var content: String?
    
    var isSelectedforDelete: Bool
    
    var message_id: String?
    
    
    init(direction: MessageDirection , type: MessageType , time: String , date: String , status: MessageReadStatus , imageURL: String? , content: String?, message_id: String?) {
        self.direction = direction
        self.type = type
        self.time = time
        self.date = date
        self.status = status
        self.imageURL = imageURL
        self.content = content
        self.isSelectedforDelete = false
        self.message_id = message_id
    }
    
}


struct MessageCodableToModelEngine {
    
    static func convert(input: DataClass) -> [MessageDataModel] {
        let datas = input.messages
        var converted_message: [MessageDataModel] = []
        
        datas?.forEach { eachMessage in
            let direction: MessageDirection = eachMessage.senderID == GrouppalChat.client_datasource?.getClientID() ?? "" ? .to : .from
            
            var type: MessageType = .text
            
            if eachMessage.messageTypeID == 1 {
                type = .text
            } else if eachMessage.messageTypeID == 2 {
                type = .image
            }
            
            let new_message = MessageDataModel(direction: direction,
                                               type: type,
                                               time: eachMessage.messageDate?.toHour ?? "",
                                               date: eachMessage.messageDate?.toHour ?? "",
                                               status: .singleTick,
                                               imageURL: type == .image ? eachMessage.message : nil ,
                                               content: eachMessage.message,
                                               message_id: eachMessage.message_id?.description ?? "")
            converted_message.append(new_message)
        }
        
        return converted_message
    }
    
}
