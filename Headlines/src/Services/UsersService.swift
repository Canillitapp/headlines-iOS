//
//  UsersService.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 25/01/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import CloudKit
import UIKit

class UsersService: HTTPService {

    func postDeviceToken(_ token: String,
                         success: ((_ response: URLResponse?) -> Void)?,
                         fail: ((_ error: Error) -> Void)?) {

        let container = CKContainer.default()
        container.fetchUserRecordID { recordId, error in
            if let err = error {
                fail?(err)
                return
            }

            guard let userId = recordId else {
                let errUserInfo = [NSLocalizedDescriptionKey: "No user record id"]
                let err = NSError(domain: "ReactionsService",
                                  code: 1,
                                  userInfo: errUserInfo)
                fail?(err)
                return
            }

            let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = {data, response in
                DispatchQueue.main.async(execute: {
                    success?(response)
                })
            }

            let failBlock: (_ error: NSError) -> Void = { e in
                DispatchQueue.main.async(execute: {
                    fail?(e as NSError)
                })
            }

            let params = [
                "device_token": token,
                "source": "iOS",
                "user_id": userId.recordName
            ]

            _ = self.request(
                method: .POST,
                path: "users/devicetoken",
                params: params,
                success: successBlock,
                fail: failBlock
            )
        }
    }
}
