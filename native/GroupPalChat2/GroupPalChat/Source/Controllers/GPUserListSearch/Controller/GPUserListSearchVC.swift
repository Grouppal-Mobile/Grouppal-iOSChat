//
//  GPUserListSearchVC.swift
//  ActiveLabel
//
//  Created by Aravind on 24/02/22.
//

import Foundation
import UIKit

class GPUserListSearchVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var listview: UITableView!
    @IBOutlet var topHolderview: UIView!
    @IBOutlet var searchHolderview: UIView!
    @IBOutlet var inputfield: UITextField!
    
    
    var default_users: GPUserListsCodable? = nil
    
    var filtered_users: GPUserListsCodable? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        self.topHolderview.backgroundColor = .white
        
        topHolderview.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        topHolderview.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        topHolderview.layer.shadowOpacity = 1.0
        topHolderview.layer.shadowRadius = 2.0
        topHolderview.layer.masksToBounds = false
        topHolderview.layer.cornerRadius = 4.0
        
        self.searchHolderview.layer.cornerRadius = self.searchHolderview.frame.height / 2
        self.searchHolderview.backgroundColor = UIColor.hexStringToUIColor(hex: "#F7F7F7")
        self.searchHolderview.layer.borderWidth = 1
        self.searchHolderview.layer.borderColor = UIColor.hexStringToUIColor(hex: "#F0F0F0").cgColor
        
        self.filtered_users = default_users
        
        self.listview.dataSource = self
        self.listview.delegate = self
        self.listview.register(UINib(nibName: "GPUserListSearchCell", bundle: GrouppalUtils.getBundle()), forCellReuseIdentifier: "GPUserListSearchCell")
        self.listview.separatorStyle = .none
        
        self.inputfield.addTarget(self, action: #selector(didChangedText), for: .editingChanged)
    }
    
    
   @objc func didChangedText() {
        if self.inputfield.text?.isEmpty ?? false {
            
            self.filtered_users = self.default_users
            self.listview.reloadData()
            
        } else {
            GrouppalChat.client_datasource?.startLoading()
            
            guard let url = URL(string: "\(GrouppalChat.client_datasource?.getEndPoint() ?? "")chat_searchname") else { return }
            let key = GrouppalChat.appType == .US ? "merchant_name" : "user_name"
            let body: [String: Any] = ["user_id": GrouppalChat.client_datasource?.getClientID() ?? "" ,
                                       "\(key)": self.inputfield.text ?? ""]
            
            ApiService.callPost(url: url, params: body) { (errorMessage , data) in
                guard let data = data,  let model = try? JSONDecoder().decode(GPUserListsCodable.self, from: data) else { return }
                self.filtered_users = model
                self.listview.reloadData()
                GrouppalChat.client_datasource?.stopLoading()
            }
            
        }
    }
}

extension GPUserListSearchVC: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered_users?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GPUserListSearchCell") as! GPUserListSearchCell
        let user = self.filtered_users?.data?[indexPath.row]
        cell.setImage(url: user?.image ?? "")
        cell.profilename.text = user?.name
        cell.lastmessage.text = user?.lastMessage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = self.filtered_users?.data?[indexPath.row].merchantID else { return }
        let controller = GPConversationListConfiguration.setup(contact_id: id,
                                                               profileimage: self.filtered_users?.data?[indexPath.row].image ?? "",
                                                               name: self.filtered_users?.data?[indexPath.row].name ?? "" ,
                                                               isonline: self.filtered_users?.data?[indexPath.row].onlineStatue ?? false)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
