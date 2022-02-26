//
//  GPConversationListVCExtension.swift
//  GroupPalChat
//
//  Created by Aravind on 23/02/22.
//

import Foundation
import UIKit

extension GPConversationListVC {
    
    func prepareFonts() {
        self.profileimageview.backgroundColor = .lightGray
        self.profileimageview.layer.cornerRadius = self.profileimageview.frame.height / 2
        
        self.profilenamelabel.text = "Aravindhan"
        self.profilestatuslabel.text = "Online"
        self.profilestatusIcon.layer.cornerRadius = self.profilestatusIcon.frame.height / 2
        
        self.profilenamelabel.font = UIFont(name: "Roboto-Bold", size: 16)
        self.profilenamelabel.textColor = .black
        self.profilestatuslabel.font = UIFont(name: "Roboto-Regular", size: 14)
        self.profilestatuslabel.textColor = UIColor.hexStringToUIColor(hex: "#9D9D9D")
        
        
        self.topHolderview.backgroundColor = .white
        
        topHolderview.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        topHolderview.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        topHolderview.layer.shadowOpacity = 1.0
        topHolderview.layer.shadowRadius = 2.0
        topHolderview.layer.masksToBounds = false
        topHolderview.layer.cornerRadius = 4.0
        
        self.bottommessageholderview.layer.cornerRadius = self.bottommessageholderview.frame.height / 2
        self.bottommessageholderview.layer.borderWidth = 1
        self.bottommessageholderview.layer.borderColor = UIColor.hexStringToUIColor(hex: "#F0F0F0").cgColor
        
        self.bottommessageholderview.backgroundColor = UIColor.hexStringToUIColor(hex: "#F7F7F7")
        self.inputtextfield.backgroundColor = .clear
        
        self.bottomHolderview.backgroundColor = .white
        
        self.inputtextfield.font = UIFont(name: "Roboto-Regular", size: 14)
        
        self.profilenamelabel.text = self.name
        self.profilestatuslabel.text = self.isOnline ? "Online" : "Offline"
        self.profilestatusIcon.backgroundColor = self.isOnline ? UIColor.hexStringToUIColor(hex: "#24A582") : .red

        
        self.blockHolderview.layer.cornerRadius = 10
        self.blockHolderview.backgroundColor = .white
        blockHolderview.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        blockHolderview.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        blockHolderview.layer.shadowOpacity = 1.0
        blockHolderview.layer.shadowRadius = 2.0
        blockHolderview.layer.masksToBounds = false
        blockHolderview.layer.cornerRadius = 4.0
        
        blockbutton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 14)
        blockbutton.setTitleColor(.black, for: .normal)
        
        
        self.profileimageview.downloaded(from: self.profileimage)
        
        self.profileimageview.contentMode = .scaleAspectFill
    }
    
    func prepareTableView() {
        self.listview.dataSource = self
        self.listview.delegate = self
        self.listview.separatorStyle = .none
        self.listview.register(UINib(nibName: "GPFromChatCell", bundle: GrouppalUtils.getBundle()), forCellReuseIdentifier: "GPFromChatCell")
        self.listview.register(UINib(nibName: "GPToChatCell", bundle: GrouppalUtils.getBundle()), forCellReuseIdentifier: "GPToChatCell")
        self.listview.register(UINib(nibName: "GPToImageCell", bundle: GrouppalUtils.getBundle()), forCellReuseIdentifier: "GPToImageCell")
        self.listview.register(UINib(nibName: "GPFromImageCell", bundle: GrouppalUtils.getBundle()), forCellReuseIdentifier: "GPFromImageCell")
        
        //FCM_IDENTIFIER
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didReceiveMessageFromFCM(notification:)),
                                               name: Notification.Name("FCM_IDENTIFIER"), object: nil)
    }
    
   
    @objc func didReceiveMessageFromFCM(notification: Notification) {
        print(notification)
        let info: String = notification.userInfo?["messages"] as? String ?? ""
        let message_dict = convertStringToDictionary(text: info)
        
        let message: MessageDataModel = MessageDataModel(direction: .from,
                                                         type: .text,
                                                         time: (message_dict?["message_date"] as? Int)?.toHour ?? "",
                                                         date: "",
                                                         status: .singleTick,
                                                         imageURL: message_dict?["message"] as? String,
                                                         content: message_dict?["message"] as? String,
                                                         message_id: (message_dict?["message_id"] as? Int)?.description)
        
        self.insertNewMessage(message: message)
    }
    
    
}

func convertStringToDictionary(text: String) -> [String:AnyObject]? {
    if let data = text.data(using: .utf8) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
            return json
        } catch {
            print("Something went wrong")
        }
    }
    return nil
}

extension GPConversationListVC {
        
    func bootInitialMessages() {
        GrouppalChat.client_datasource?.startLoading()
        self.interactor?.triggerInitialMessages()
    }
    
    public func triggerPaginationAPI() {
        if self.noMorePagination { return }
        fetch_time += 1
        self.interactor?.triggerPaginationAPI(page: fetch_time)
        GrouppalChat.client_datasource?.startLoading()
    }
    
    func insertNewMessage(message: Message) {
        self.messages.append(message)
        self.listview.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .bottom)
        self.listview.scrollToBottom()
        
        self.interactor?.triggerSendMessageAPI(message: message, index: IndexPath(row: self.messages.count - 1, section: 0))

    }
    
}


extension GPConversationListVC: GPConversationInteractorDelegates {
    
    func didInitalMessagesCompleted(messages: [Message], isBlocked: Bool) {
        self.isBlocked = isBlocked
        self.messages = messages
        self.listview.reloadData()
        
        self.listview.isHidden = true
        self.listview.scrollToBottom()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            GrouppalChat.client_datasource?.stopLoading()
            self.listview.isHidden = false
            self.isVisibiled = true
        }
    }
    
    func didPaginationMessagesCompleted(messages: [Message] , page: Int) {
        if messages.count == .zero {
            self.noMorePagination = true;
            GrouppalChat.client_datasource?.stopLoading()
            return
        }
        
        var array_indexpath: [IndexPath] = []
        
        let new_message_count = messages.count
        
        var i = 0
        messages.forEach { eachmessage in
            self.messages.insert(eachmessage, at: 0)
            array_indexpath.append(IndexPath(row: i, section: 0))
            i += 1
        }
        
        self.listview.smoothlyMoveToMessage(scrollToIndex: IndexPath(row: new_message_count, section: 0), array_indexpath: array_indexpath)
        GrouppalChat.client_datasource?.stopLoading()
    }
    
    
    func triggerSendMessageAPICompelted(index: IndexPath , status: Bool, message: Message) {
        self.messages[index.row].message_id = message.message_id
        self.listview.reloadRows(at: [index], with: .automatic)
    }

    func triggerBlockAPICompleted() {
        self.isBlocked = !self.isBlocked
        self.bottomHolderview.isHidden = isBlocked
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.bottomconstraint.constant = self.isBlocked ? -100 : 0
            self.bottomHolderview.layoutIfNeeded()
        })
        
        GrouppalChat.client_datasource?.stopLoading()
    }
}
