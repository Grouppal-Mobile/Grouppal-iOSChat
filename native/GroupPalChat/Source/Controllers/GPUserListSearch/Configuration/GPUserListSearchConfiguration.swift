//
//  GPUserListSearchConfiguration.swift
//  ActiveLabel
//
//  Created by Aravind on 24/02/22.
//

import Foundation
import UIKit

class GPUserListSearchConfiguration {
    
    static func setup(default_users: GPUserListsCodable?) -> GPUserListSearchVC {
        let storyboard = UIStoryboard(name: "GPConversationList", bundle: GrouppalUtils.getBundle())
        let controller = storyboard.instantiateViewController(withIdentifier: "GPUserListSearchVC") as! GPUserListSearchVC
        controller.default_users = default_users
        controller.hidesBottomBarWhenPushed = GrouppalChat.appType == .US
        return controller
    }
    
}
