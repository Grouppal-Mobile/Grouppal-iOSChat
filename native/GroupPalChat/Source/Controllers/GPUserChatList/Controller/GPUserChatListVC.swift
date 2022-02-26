//
//  GPUserChatListVC.swift
//  GroupPalChat
//
//  Created by Aravind on 23/02/22.
//

import Foundation
import UIKit

class GPUserChatListVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var topHolderview: UIView!
    @IBOutlet var listview: UITableView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var leftbackicon: UIImageView!
    
    
    var interactor: GPUserChatListInteractor? = nil
    
    var datasource: GPUserListsCodable? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        
        self.prepareFonts()
        self.prepareListView()
        self.interactor?.triggerListAPI(page: 0)
    }
    
    func prepareFonts() {
        self.topHolderview.backgroundColor = .white
        
        topHolderview.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        topHolderview.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        topHolderview.layer.shadowOpacity = 1.0
        topHolderview.layer.shadowRadius = 2.0
        topHolderview.layer.masksToBounds = false
        topHolderview.layer.cornerRadius = 4.0
        
        titleLabel.text = GrouppalChat.appType == .BL ? "Customers" : "Merchants"
        self.leftbackicon.isHidden = GrouppalChat.appType == .BL
    }
    
    func prepareListView() {
        self.listview.dataSource = self
        self.listview.delegate = self
        self.listview.separatorStyle = .none
        self.listview.register(UINib(nibName: "GPUserListCell", bundle: GrouppalUtils.getBundle()), forCellReuseIdentifier: "GPUserListCell")
    }
    
    
    @IBAction func searchTapped() {
        let controller = GPUserListSearchConfiguration.setup(default_users: self.datasource)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension GPUserChatListVC: GPUserChatListInteractorDelegate {
 
    func listAPICompleted(model: GPUserListsCodable) {
        self.datasource = model
        self.listview.reloadData()
    }
 
}

extension GPUserChatListVC: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource?.data?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GPUserListCell") as! GPUserListCell
        cell.profilenamelabel.text = self.datasource?.data?[indexPath.row].name
        cell.lastmessagelabel.text = self.datasource?.data?[indexPath.row].lastMessage
        cell.setImage(url: self.datasource?.data?[indexPath.row].image ?? "")
        cell.timelabel.text = self.datasource?.data?[indexPath.row].time?.toHour ?? ""
        cell.unreadCountLabel.text = self.datasource?.data?[indexPath.row].unreadCount?.description
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = self.datasource?.data?[indexPath.row].merchantID else { return }
        let controller = GPConversationListConfiguration.setup(contact_id: id,
                                                               profileimage: self.datasource?.data?[indexPath.row].image ?? "",
                                                               name: self.datasource?.data?[indexPath.row].name ?? "" ,
                                                               isonline: self.datasource?.data?[indexPath.row].onlineStatue ?? false)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

typealias UnixTime = Int

extension UnixTime {
    private func formatType(form: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = form
        return dateFormatter
    }
    var dateFull: Date {
        return Date(timeIntervalSince1970: Double(self))
    }
    var toHour: String {
        return formatType(form: "HH:mm").string(from: dateFull)
    }
    var toDay: String {
        return formatType(form: "MM/dd/yyyy").string(from: dateFull)
    }
}

