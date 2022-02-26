//
//  GPFromChatCell.swift
//  ActiveLabel
//
//  Created by Aravind on 22/02/22.
//

import UIKit

class GPFromChatCell: UITableViewCell {

    
    @IBOutlet var holderview: UIView!
    @IBOutlet var messagelabel: UILabel!
    @IBOutlet var timelabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        self.messagelabel.font = UIFont(name: "Roboto-Regular", size: 14)

        holderview.roundCorners(corners: [.topLeft , .topRight , .bottomRight], radius: 20)
        self.backgroundColor = .white

        self.timelabel.font = UIFont(name: "Roboto-Regular", size: 12)
        self.timelabel.textColor = UIColor.hexStringToUIColor(hex: "#9D9D9D")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            var masked = CACornerMask()
            if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
            if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
            if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
            if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
            self.layer.maskedCorners = masked
        }
        else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }



}
    
