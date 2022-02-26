//
//  GPUserListSearchCell.swift
//  GroupPalChat
//
//  Created by Aravind on 24/02/22.
//

import UIKit

class GPUserListSearchCell: UITableViewCell {
    
    @IBOutlet var profileimageview: UIImageView!
    @IBOutlet var profilename: UILabel!
    @IBOutlet var lastmessage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.profileimageview.layer.cornerRadius = self.profileimageview.frame.height / 2
        
        self.profilename.font = UIFont(name: "Roboto-Regular", size: 16)
        self.profilename.textColor = UIColor.hexStringToUIColor(hex: "#111111")
        
        self.lastmessage.font = UIFont(name: "Roboto-Regular", size: 14)
        self.lastmessage.textColor = UIColor.hexStringToUIColor(hex: "#9D9D9D")

    }

  
    func setImage(url: String) {
        self.profileimageview.downloaded(from: url)
    }
    
}
