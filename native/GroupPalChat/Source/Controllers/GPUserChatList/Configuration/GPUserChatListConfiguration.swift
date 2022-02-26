//
//  GPUserChatListConfiguration.swift
//  GroupPalChat
//
//  Created by Aravind on 23/02/22.
//

import Foundation
import UIKit

class GPUserChatListConfiguration {
    
    static func setup() -> UIViewController {
        let storyboard = UIStoryboard(name: "GPConversationList", bundle: GrouppalUtils.getBundle())
        let controller = storyboard.instantiateViewController(withIdentifier: "GPUserChatListVC") as! GPUserChatListVC
        let interactor = GPUserChatListInteractor()
        controller.hidesBottomBarWhenPushed = GrouppalChat.appType == .US 
        interactor.delegate = controller
        controller.interactor = interactor
        return controller
    }
    
}
