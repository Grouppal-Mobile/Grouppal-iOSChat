//
//  GPUserChatListInteractor.swift
//  GroupPalChat
//
//  Created by Aravind on 23/02/22.
//

import Foundation
import UIKit

protocol GPUserChatListInteractorDataSource {
    func triggerListAPI(page: Int)
}

protocol GPUserChatListInteractorDelegate {
    func listAPICompleted(model: GPUserListsCodable)
}

class GPUserChatListInteractor: GPUserChatListInteractorDataSource {
    
    var delegate: GPUserChatListInteractorDelegate? = nil
    
    func triggerListAPI(page: Int) {
        guard let url = URL(string: "\(GrouppalChat.client_datasource?.getEndPoint() ?? "")chat_view") else { return }
        let body: [String: Any] = ["user_id": GrouppalChat.client_datasource?.getClientID() ?? "" ,
                                   "page": page]
        ApiService.callPost(url: url, params: body) { (errorMessage , data) in
            guard let data = data,  let model = try? JSONDecoder().decode(GPUserListsCodable.self, from: data) else { return }
            self.delegate?.listAPICompleted(model: model)
        }
    }
    
}
