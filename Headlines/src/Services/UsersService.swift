//
//  UsersService.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 25/01/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit
import CloudKit

class UsersService: HTTPService {

    func postDeviceToken(_ token: String,
                         handler: ((_ result: Result<Data?, Error>) -> Void)?) {

        let container = CKContainer.default()
        container.fetchUserRecordID { (recordId, error) in
            if let err = error {
                handler?(.failure(err))
                return
            }

            guard let userId = recordId else {
                let errUserInfo = [NSLocalizedDescriptionKey: "No user record id"]
                let err = NSError(domain: "ReactionsService",
                                  code: 1,
                                  userInfo: errUserInfo)
                handler?(.failure(err))
                return
            }

            let params = [
                "device_token": token,
                "source": "iOS",
                "user_id": userId.recordName
            ]

            let httpHandler: ((Result <Data?, Error>) -> Void) = { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async(execute: {
                        handler?(.success(data))
                    })

                case .failure(let error):
                    DispatchQueue.main.async(execute: {
                        handler?(.failure(error))
                    })
                    return
                }
            }

            _ = self.request(method: .POST, path: "users/devicetoken", params: params, handler: httpHandler)
        }
    }
}
