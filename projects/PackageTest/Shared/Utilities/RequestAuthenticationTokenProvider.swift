//
//  RequestAuthenticationTokenProvider.swift
//  WBExample
//
//  Created by Sarath Kumar G on 03/04/23.
//  Copyright © 2023 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
import Helper
import Whiteboard

class RequestAuthenticationTokenProvider: NSObject, RequestAuthenticationTokenProviderAPI {
    func token(handler: @escaping (String?, Error?) -> Void) {
        Dependencies.authenticator.authToken { token, _, error in
            handler(token, error)
        }
    }

    func getMDMToken() -> String? {
        Dependencies.authenticator.getMDMToken()
    }

    func getDeviceID() -> String? {
        Dependencies.authenticator.getDeviceID()
    }

    deinit {
        Debugger.deInit(self.classForCoder)
    }
}
