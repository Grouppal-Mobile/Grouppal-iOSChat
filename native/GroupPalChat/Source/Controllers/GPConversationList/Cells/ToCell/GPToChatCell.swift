//
//  GPToChatCell.swift
//  GroupPalChat
//
//  Created by Aravind on 22/02/22.
//

import UIKit

class GPToChatCell: UITableViewCell {

    
    @IBOutlet var holderview: UIView!
    @IBOutlet var messagelabel: UILabel!
    @IBOutlet var timelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        self.messagelabel.font = UIFont(name: "Roboto-Regular", size: 14)

        holderview.roundCorners(corners: [.topLeft , .topRight , .bottomLeft], radius: 20)
        self.backgroundColor = .white
        
        self.timelabel.font = UIFont(name: "Roboto-Regular", size: 12)
        self.timelabel.textColor = UIColor.hexStringToUIColor(hex: "#9D9D9D")
    }

 
}
