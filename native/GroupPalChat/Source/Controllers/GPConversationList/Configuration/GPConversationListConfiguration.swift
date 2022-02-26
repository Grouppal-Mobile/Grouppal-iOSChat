//
//  GPConversationListConfiguration.swift
//  GroupPalChat
//
//  Created by Aravind on 22/02/22.
//

import Foundation
import UIKit

public class GPConversationListConfiguration {
    
    static func setup(contact_id: String, profileimage: String, name: String, isonline: Bool) -> GPConversationListVC {
        let storyboard = UIStoryboard(name: "GPConversationList", bundle: GrouppalUtils.getBundle())
        let controller = storyboard.instantiateViewController(withIdentifier: "GPConversationListVC") as! GPConversationListVC
        let interactor = GPConversationListInteractor()
        interactor.contact_id = contact_id
        interactor.delegate = controller
        controller.interactor = interactor
        controller.profileimage = profileimage
        controller.name = name
        controller.isOnline = isonline
        return controller
    }
    
}
