//
//  SearchUserHelper.swift
//  Swift Chat Demo
//
//  Created by atwork on 2/12/2016.
//  Copyright © 2016 Skygear. All rights reserved.
//

import UIKit
import SKYKit
import SKYKitChat
import SVProgressHUD

extension UIViewController {

    func chat_startSearchUserFlow(completion: ((_ record: SKYRecord?) -> Void)?) {
        let alert = UIAlertController(title: "Search User", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Username"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            if let username = alert.textFields?.first?.text {
                self.chat_startSearchUserFlow(username: username, completion: completion)
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    func chat_startSearchUserFlow(username: String, completion: ((_ record: SKYRecord?) -> Void)?) {
        let container = SKYContainer.default()!

        SVProgressHUD.show()
        container.queryUsers(byUsernames: [username]) { (records, err) in
            SVProgressHUD.dismiss()
            if let error = err {
                let alert = UIAlertController(title: "Cannot Find User", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                completion?(nil)
                return
            }

            guard let foundUser = records?.first else {
                SVProgressHUD.showError(withStatus: "User Not Found")
                completion?(nil)
                return
            }

            ChatHelper.shared.cacheUserRecord(foundUser)
            completion?(foundUser)
        }
    }
}
