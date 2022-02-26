//
//  GPConversationListVC.swift
//  GroupPalChat
//
//  Created by Aravind on 22/02/22.
//

import Foundation
import UIKit

public class GPConversationListVC: UIViewController , UIGestureRecognizerDelegate {
    
    @IBOutlet var backicon: UIImageView!
    @IBOutlet var profileimageview: UIImageView!
    @IBOutlet var profilenamelabel: UILabel!
    @IBOutlet var profilestatuslabel: UILabel!
    @IBOutlet var profilestatusIcon: UIImageView!
    @IBOutlet var moreIcon: UIImageView!
    @IBOutlet var deleteIcon: UIImageView!
    
    @IBOutlet var topHolderview: UIView!
    @IBOutlet var bottomHolderview: UIView!
    
    @IBOutlet var listview: UITableView!
    
    @IBOutlet var bottommessageholderview: UIView!
    @IBOutlet var inputtextfield: UITextField!
    @IBOutlet var attachmenticon: UIImageView!
    @IBOutlet var sendicon: UIImageView!
    
    @IBOutlet var bottomconstraint: NSLayoutConstraint!
    
    @IBOutlet var blockHolderview: UIView!
    @IBOutlet var blockbutton: UIButton!
    
    var isVisibiled: Bool = false
    
    var messages: [Message] = []
    
    var profileimage: String = ""
    
    var name: String = ""
    var isOnline: Bool = false
    
    var fetch_time = 0
    
    var keyboardheight: CGFloat? = nil
    
    var noMorePagination: Bool = false
    
    var interactor: GPConversationListInteractorDataSource? = nil
    
    var deleteSelectedColor: UIColor = .lightGray
    
    var isBlocked: Bool = false {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.blockbutton.setTitle(self.isBlocked ? "UnBlock" : "Block", for: .normal)
                self.bottomHolderview.isHidden = self.isBlocked
            }
        }
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.prepareFonts()
        self.prepareTableView()
        self.bootInitialMessages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        GrouppalChat.didImageDownloaded = { [weak self] imageURL , image in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let today = Date()
                // 2. Pick the date components
                let hours   = (Calendar.current.component(.hour, from: today))
                let minutes = (Calendar.current.component(.minute, from: today))

                
                let message = MessageDataModel(direction: .to, type: .image, time: "\(hours):\(minutes)", date: "", status: .singleTick, imageURL: imageURL, content: nil, message_id: "")
                self.insertNewMessage(message: message)
            }
        }
        
        self.blockHolderview.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.deleteIcon.isHidden = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GrouppalChat.isShowNotificationBanner = false
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        GrouppalChat.isShowNotificationBanner = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardheight == nil {
                self.keyboardheight = keyboardSize.height - 20
            }
            self.listview.scrollToBottom()
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.bottomconstraint.constant = self.keyboardheight ?? .zero
                self.bottomHolderview.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.bottomconstraint.constant = 0
                self.listview.contentInset.bottom = 0
                self.bottomHolderview.layoutIfNeeded()
            })
     
    }
    
    @IBAction func sendButtonTapped() {
        let content = self.inputtextfield.text
        let message = MessageDataModel(direction: .to, type: .text, time: "15.00", date: "", status: .singleTick, imageURL: nil, content: content, message_id: "")
        self.insertNewMessage(message: message)
        self.inputtextfield.text = ""
    }
    
    @IBAction func attachmentTapped() {
        GrouppalChat.client_datasource?.didopenAttachmedPicker(topView: self.view, controller: self)
    }
    
    @IBAction func blockTapped() {
        UIView.animate(withDuration: 0.5) {
            self.blockHolderview.transform = .identity
        }
    }
    
    @IBAction func blockButtonTapped(){
        GrouppalChat.client_datasource?.startLoading()
        self.interactor?.triggerBlockAPI(isBlocked: !isBlocked)
        
        UIView.animate(withDuration: 0.5) {
            self.blockHolderview.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        
        
    }
    
    @IBAction func deleteTapped() {
        let message = self.messages.filter({$0.isSelectedforDelete})
        if message.count == 0 { return }
        self.interactor?.triggerDeleteAPI(messages: message)
        
        self.messages.removeAll { eachmessage in
            message.contains(where: {$0.message_id ?? "" == eachmessage.message_id})
        }
        
        self.listview.reloadData()
        self.listview.scrollToBottom()
        
        
    }
    
}


extension GPConversationListVC: UITableViewDataSource , UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch messages[indexPath.row].direction {
        case .from:
            if messages[indexPath.row].type == .image {
                return self.prepareFromImageCell(tableView, cellForRowAt: indexPath)
            } else {
                return self.prepareFromTextCell(tableView, cellForRowAt: indexPath)
            }
            

        case .to:
            if messages[indexPath.row].type == .image {
                return self.prepareToImageCell(tableView, cellForRowAt: indexPath)
            } else {
                return self.prepareToTextCell(tableView, cellForRowAt: indexPath)
            }
           
        }
        
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if messages[indexPath.row].type == .image { return 240 }
        return UITableView.automaticDimension
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var message = messages[indexPath.row]
        message.isSelectedforDelete = !message.isSelectedforDelete
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = message.isSelectedforDelete ? deleteSelectedColor : .white
        
        let count = self.messages.filter({$0.isSelectedforDelete}).count
        self.deleteIcon.isHidden = count == 0
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        self.blockHolderview.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.listview.isReachedTop() {
            self.triggerPaginationAPI()
        }
        
    }
    
    func prepareFromTextCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GPFromChatCell") as! GPFromChatCell
        let message = messages[indexPath.row]
        cell.messagelabel.text = message.content ?? "NIL"
            
        cell.timelabel.text = message.time
        cell.backgroundColor = message.isSelectedforDelete ? deleteSelectedColor : .white
        
        return cell
    }
    
    
    func prepareToTextCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GPToChatCell") as! GPToChatCell
        let message = messages[indexPath.row]

        cell.messagelabel.text = message.content ?? "NIL"
        cell.timelabel.text = message.time
        cell.backgroundColor = message.isSelectedforDelete ? deleteSelectedColor : .white
        
        return cell
    }
    
    func prepareFromImageCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GPFromImageCell") as! GPFromImageCell
        let message = messages[indexPath.row]
        cell.timelabel.text = message.time

        
        cell.setimage(url: message.imageURL)
        cell.backgroundColor = message.isSelectedforDelete ? deleteSelectedColor : .white
        
        return cell
    }
    
    func prepareToImageCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GPToImageCell") as! GPToImageCell
        let message = messages[indexPath.row]
        cell.timelabel.text = message.time

        
        cell.setimage(url: message.imageURL)
        
        cell.backgroundColor = message.isSelectedforDelete ? deleteSelectedColor : .white
        
        return cell
    }
}



