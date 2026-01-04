//
//  Authenticator.swift
//  WBExample
//
//  Created by magesh-temp on 23/08/23.
//  Copyright © 2023 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
import Whiteboard

class BaseAuthenticator: NSObject {
    final let clientId = "1002.6FJC8OEN1UAND8QXSQXGNY192ZF26Z"
    let wbIntegType = WBIntegType.meeting(isKnownUser: true)
    var currentUserZUID: String? {
        ""
    }

    var isUserSignedIn: Bool {
        let userDefault = UserDefaults.standard
        return userDefault.bool(forKey: "IsUserSignedIn")
    }

    let scopes: [String] = [
        "Whiteboard.projects.ALL",
        "WhiteBoard.documents.ALL"
    ]

    var urlScheme: String {
        "remoteboard"
    }

    func getAuthToken(handler _: @escaping (String?, Int64, Error?) -> Void) {
        fatalError("Must be implemented by inheriting class")
    }

    func getMDMTokenFromSSO() -> String? {
        fatalError("Must be implemented by inheriting class")
    }

    func getDeviceIDFromSSO() -> String? {
        fatalError("Must be implemented by inheriting class")
    }

    deinit {
        Debugger.deInit(self.classForCoder)
    }
}

extension BaseAuthenticator {
    func setIsUserSignedIn(signedIn: Bool) {
        let userDefault = UserDefaults.standard
        userDefault.setValue(signedIn, forKey: "IsUserSignedIn")
    }

    func handleLogOutCompletion(
        _ error: Error?,
        _ completionBlock: @escaping () -> Void
    ) {
        if let error = error {
            Debugger.error("Sign out failure - \(error)")
        } else {
            self.setIsUserSignedIn(signedIn: false)
            Debugger.debug("Sign out successful")
        }
        completionBlock()
    }
}

extension BaseAuthenticator: AuthenticatorAPI {
    var domain: String {
        "whiteboard.zoho.com"
    }

    var dclBaseDomain: String {
        "zoho.com"
    }

    var currentUserId: String? {
        self.currentUserZUID
    }

    var aditionalParams: [String: String]? {
        let dict: [String: Any] = [
            "idType": "meeting",
            "ownerzuid": 659_688_090,
            "sessionId": "664000074579089",
            "id": "664000074579509",
            "orgId": 53_296_550
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            if let value = String(data: jsonData, encoding: .utf8) {
                return ["clientParams": value]
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    var dclPrefix: String? {
        nil
    }

    var hostPrefix: String {
        "wms"
    }

    var useNativeWebSocket: Bool {
        true
    }

    func authToken(handler: @escaping (String?, Int64, Error?) -> Void) {
        if self.wbIntegType.isKnownUser {
            self.getAuthToken(handler: handler)
        } else {
            handler("wmsAnnonUserId", 0, nil)
        }
    }

    func getMDMToken() -> String? {
        self.getMDMTokenFromSSO()
    }

    func getDeviceID() -> String? {
        self.getDeviceIDFromSSO()
    }
}
