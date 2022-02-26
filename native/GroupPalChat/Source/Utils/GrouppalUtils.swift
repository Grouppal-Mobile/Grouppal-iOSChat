//
//  GrouppalUtils.swift
//  GroupPalChat
//
//  Created by Aravind on 22/02/22.
//

import Foundation
import UIKit

class GrouppalUtils {
    
//    static var merchant_ID: String = "m_1"
//    static var client_ID: String = "u_66093"
    static var auth_tocken: String = GrouppalChat.client_datasource?.getAuthTocken() ?? "" //"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIiwianRpIjoie1wib3duZXJcIjpcInVzZXJcIixcInVpZFwiOjY2MDkzLFwiZXhwXCI6MTY3NTE3NzM5Nn0ifQ.eyJpc3MiOiJodHRwOlwvXC9ncm91cHBhbC5pbiIsImlhdCI6MTY0MzY0MTM5NiwibmJmIjoxNjQzNjQxMzk2LCJleHAiOjE2NzUxNzczOTYsInVpZCI6NjYwOTMsImp0aSI6IntcIm93bmVyXCI6XCJ1c2VyXCIsXCJ1aWRcIjo2NjA5MyxcImV4cFwiOjE2NzUxNzczOTZ9In0"
    
    public static func getBundle(fromResource resource: String = "GroupPalChat", ofType type: String = "framework", throughDirectory directory: String = "Frameworks") -> Bundle? {
        let bundle = Bundle.allFrameworks.first { (bundle) -> Bool in
            return bundle.bundleURL.lastPathComponent == "\(resource).\(type)"
        }
        return bundle
    }
    
}

extension UIColor {
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}



extension UITableView {

    func scrollToBottom(isAnimated:Bool = true){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                if indexPath.row < 0 || indexPath.section < 0 { return }
                self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
            }
        }
    }

    func scrollToTop(isAnimated:Bool = true) {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
}

extension UITableView {
    func smoothlyMoveToMessage(scrollToIndex: IndexPath, array_indexpath: [IndexPath]) {
        UIView.transition(with: self, duration: 0.05, options: .transitionCrossDissolve) {
            self.isHidden = true
            
        } completion: { isCompleted in
            if !isCompleted { return }
            
            self.insertRows(at: array_indexpath, with: .none)
            self.scrollToRow(at: scrollToIndex,
                             at: UITableView.ScrollPosition.top,
                             animated: false)
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                UIView.transition(with: self, duration: 0.1,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    self.isHidden = false
                    
                })
            }
        }
    }
    
    func isReachedTop() -> Bool {
        return self.contentSize.height > 0 &&
        ((self.contentOffset.y + self.safeAreaInsets.top) == 0)
    }
    
}
