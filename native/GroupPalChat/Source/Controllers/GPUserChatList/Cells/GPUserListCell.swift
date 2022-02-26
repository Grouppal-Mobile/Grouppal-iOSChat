//
//  GPUserListCell.swift
//  GroupPalChat
//
//  Created by Aravind on 23/02/22.
//

import UIKit

class GPUserListCell: UITableViewCell {

    @IBOutlet var profileimageview: UIImageView!
    @IBOutlet var profilenamelabel: UILabel!
    @IBOutlet var lastmessagelabel: UILabel!
    @IBOutlet var timelabel: UILabel!
    @IBOutlet var statusView: UIView!
    @IBOutlet var unreadCountLabel: UILabel!
    @IBOutlet var unreadholderview: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        self.profileimageview.layer.cornerRadius = self.profileimageview.frame.height / 2
        self.statusView.layer.cornerRadius = self.statusView.frame.height / 2
        self.statusView.backgroundColor = UIColor.hexStringToUIColor(hex: "#24A582")
        self.statusView.layer.borderWidth = 2
        self.statusView.layer.borderColor = UIColor.white.cgColor
        
        self.profilenamelabel.font = UIFont(name: "Roboto-Regular", size: 16)
        self.profilenamelabel.textColor = .black
        
        self.lastmessagelabel.font = UIFont(name: "Roboto-Regular", size: 14)
        self.lastmessagelabel.textColor = UIColor.hexStringToUIColor(hex: "#9D9D9D")
        
        self.timelabel.textColor = UIColor.hexStringToUIColor(hex: "#9D9D9D")
        self.timelabel.font = UIFont(name: "Roboto-Regular", size: 14)

        self.unreadholderview.layer.cornerRadius = self.unreadholderview.frame.height / 2
        self.unreadholderview.backgroundColor = UIColor.hexStringToUIColor(hex: "#2439A5")
        
        self.unreadCountLabel.textColor = .white
        self.unreadCountLabel.font = UIFont(name: "Roboto-Bold", size: 14)
        self.profileimageview.contentMode = .scaleAspectFill
    }

    
    func setImage(url: String) {
        if let url = URL(string: url) {
            GrouppalChat.client_datasource?.downloadImage(imageview: self.profileimageview, url: url)
        }
    }
    
}

extension UIImageView {
     
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        GrouppalChat.client_datasource?.downloadImage(imageview: self, url: url)
    }
}
