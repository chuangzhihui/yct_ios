//
//  LodinLineManager.swift
//  LineSDKStarterObjC
//
//  Created by Noman Umar on 19/09/2024.
//  Copyright © 2024 LINE. All rights reserved.
//

import Foundation
import UIKit
import LineSDK

@objc class LineLoginManager: NSObject  {
    
    @objc static let shared = LineLoginManager()
    
    private override init() {
        // Configure LINE SDK with your channel ID
        let link = URL(string: "https://yct.vnppp.net/line-auth/")
        LineSDKLoginManager.sharedManager.setup(channelID: "2006282696", universalLinkURL: link)
    }
    
    @objc func login(from viewController: UIViewController, completion: @escaping (String?, String?, Error?) -> Void) {
        // Create a Set of permissions
        let permissions: Set<LineSDKLoginPermission> = [.profile]  // Request profile permission
        
        LineSDKLoginManager.sharedManager.login(permissions: permissions, inViewController: viewController) { result, error in
            if let error = error {
                print("Error during LINE login: \(error.localizedDescription)")
                completion(nil, nil, error)
            } else if let result = result {
                // Handle successful login
                if let profile = result.userProfile {
                    let userID = profile.userID
                    let displayName = profile.displayName
                    
                    // Log the user ID and display name
                    print("User ID: \(userID)")
                    print("Display Name: \(displayName)")
                    
                    // Pass the user ID and name through the completion handler
                    completion(userID, displayName, nil)
                } else {
                    // If the profile is missing, handle the error
                    completion(nil, nil, NSError(domain: "LineSDK", code: -1, userInfo: [NSLocalizedDescriptionKey: "Profile not found"]))
                }
            }
        }
    }


}
