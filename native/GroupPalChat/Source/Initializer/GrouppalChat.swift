//
//  GrouppalChat.swift
//  GroupPalChat
//
//  Created by Aravind on 22/02/22.
//

import Foundation
import UIKit

public protocol GrouppalChatDataSource {
    func getEndPoint() -> String
    func getClientID() -> String
    func getAuthTocken() -> String
    func getFCMTocken() -> String
    func downloadImage(imageview: UIImageView , url: URL)
    func startLoading()
    func stopLoading()
    func didopenAttachmedPicker(topView: UIView, controller: UIViewController)
}

public enum AppType {
    case BL
    case US
}


public class GrouppalChat {
    
    internal static var client_datasource: GrouppalChatDataSource? = nil
    public static var didImageDownloaded: ((String?, UIImage?) -> ())? = nil
    public static var appType: AppType = .US
    
    public static var isShowNotificationBanner: Bool = true
    
    public static var fcminfo: [AnyHashable : Any] = [:] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("FCM_IDENTIFIER"), object: nil, userInfo: fcminfo)
        }
    }

    public var datasource: GrouppalChatDataSource? = nil {
        didSet {
            GrouppalChat.client_datasource = datasource
        }
    }
    
    public init() {
       
    }
    
    public func getChatListPage() -> UIViewController {
        return GPUserChatListConfiguration.setup()
    }
}
