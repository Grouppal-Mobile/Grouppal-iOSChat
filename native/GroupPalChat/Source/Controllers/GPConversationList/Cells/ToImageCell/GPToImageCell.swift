//
//  GPToImageCell.swift
//  GroupPalChat
//
//  Created by Aravind on 23/02/22.
//

import UIKit

class GPToImageCell: UITableViewCell {

    @IBOutlet var attachimageview: UIImageView!
    @IBOutlet var timelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.attachimageview.layer.cornerRadius = 20
        
        self.timelabel.font = UIFont(name: "Roboto-Regular", size: 12)
        self.timelabel.textColor = UIColor.hexStringToUIColor(hex: "#9D9D9D")

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.attachimageview.image = nil
    }
    
    func setimage(url: String?) {
        guard let url = URL(string: url ?? "") else { return }
        GrouppalChat.client_datasource?.downloadImage(imageview: self.attachimageview, url: url)

    }
    
}
