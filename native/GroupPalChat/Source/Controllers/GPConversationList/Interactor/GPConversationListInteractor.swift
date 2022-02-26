//
//  GPConversationListInteractor.swift
//  GroupPalChat
//
//  Created by Aravind on 23/02/22.
//

import Foundation
import UIKit
import Alamofire

class GPConversationListInteractor: GPConversationListInteractorDataSource {
    
    var delegate: GPConversationInteractorDelegates? = nil
    
    var contact_id: String = ""
    
    func triggerInitialMessages() {
        guard let url = URL(string: "\(GrouppalChat.client_datasource?.getEndPoint() ?? "")chat_api") else { return }
        
        ApiService.callPost(url: url, params: ["user_id": GrouppalChat.client_datasource?.getClientID() ?? "" ,
                                               "contact_id": contact_id ,
                                               "fcm_token": GrouppalChat.client_datasource?.getFCMTocken() ?? "" ,
                                               "page": 0]) { (message , data) in
            guard let data = data,  let messagesCodable = try? JSONDecoder().decode(MessagesCodable.self, from: data) , let messages = messagesCodable.data else { return }
            let convertedModel = MessageCodableToModelEngine.convert(input: messages)
            self.delegate?.didInitalMessagesCompleted(messages: convertedModel.reversed(), isBlocked: messages.profileDetails?.block_status ?? .zero == 1 ? true : false)
        }
    }
    
    
    func triggerPaginationAPI(page: Int) {
        guard let url = URL(string: "\(GrouppalChat.client_datasource?.getEndPoint() ?? "")chat_api") else { return }
        
        ApiService.callPost(url: url, params: ["user_id": GrouppalChat.client_datasource?.getClientID() ?? "" ,
                                               "contact_id": contact_id,
                                               "fcm_token": GrouppalChat.client_datasource?.getFCMTocken() ?? "",
                                               "page": page]) { (message , data) in
            guard let data = data,  let messagesCodable = try? JSONDecoder().decode(MessagesCodable.self, from: data), let messages = messagesCodable.data else { return }
            let convertedModel = MessageCodableToModelEngine.convert(input: messages)
            self.delegate?.didPaginationMessagesCompleted(messages: convertedModel.reversed(), page: page)
        }
        
    }
    
    
    func triggerSendMessageAPI(message: Message , index: IndexPath) {
        guard let url = URL(string: "\(GrouppalChat.client_datasource?.getEndPoint() ?? "")chat_send") else { return }

        let params: [String : Any] = ["sender_id": GrouppalChat.client_datasource?.getClientID() ?? "" ,
                                      "receiver_id": self.contact_id,
                      "message": message.content ?? "",
                      "message_type_id": message.type == .image ? 2 : 1,
                      "message_date": ""]
        
        ApiService.callPost(url: url, params: params) { (messageinfo , data) in
            self.delegate?.triggerSendMessageAPICompelted(index: index, status: true, message: message)
        }
        
    }
    
    func triggerBlockAPI(isBlocked: Bool) {
        guard let url = URL(string: "\(GrouppalChat.client_datasource?.getEndPoint() ?? "")chat_block") else { return }
        let params: [String : Any] = ["user_id": GrouppalChat.client_datasource?.getClientID() ?? "" ,
                                      "block_id": self.contact_id,
                                      "status": isBlocked ? 1 : 0]
        ApiService.callPost(url: url, params: params) { (message , data) in
            self.delegate?.triggerBlockAPICompleted()
        }
    }
    
    func triggerDeleteAPI(messages: [Message]) {
        guard let url = URL(string: "\(GrouppalChat.client_datasource?.getEndPoint() ?? "")chat_deletemessage") else { return }
        var ids: [[String: Any]] = []
        
        messages.forEach { eachmessage in
            var newID: [String: Any] = [:]
            newID["id"] = eachmessage.message_id
            ids.append(newID)
        }
        
       

        let params: [String : Any] = ["ids": stringify(json: ids) ,
                                      "user_id": GrouppalChat.client_datasource?.getClientID() ?? "",
                                      "contact_id": self.contact_id]
        
        let header: HTTPHeaders = ["Authorization": GrouppalUtils.auth_tocken]
        
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.queryString, headers: header).responseJSON { response in
            
            
        }
        
           
    }
}

func stringify(json: Any, prettyPrinted: Bool = false) -> String {
   var options: JSONSerialization.WritingOptions = []
   if prettyPrinted {
     options = JSONSerialization.WritingOptions.prettyPrinted
   }

   do {
     let data = try JSONSerialization.data(withJSONObject: json, options: options)
     if let string = String(data: data, encoding: String.Encoding.utf8) {
       return string
     }
   } catch {
    debugPrint(error)
   }

   return ""
}

extension String {
    mutating func replace(_ originalString:String, with newString:String) {
        self = self.replacingOccurrences(of: originalString, with: newString)
    }
}
