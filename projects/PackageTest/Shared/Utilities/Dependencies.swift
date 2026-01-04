//
//  Dependencies.swift
//  WhiteBoard
//
//  Created by Subramanian on 21/06/21.
//  Copyright © 2021 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
import Whiteboard

class Dependencies: NSObject {
    static let authenticator = Authenticator()
    static let tokenProvider = RequestAuthenticationTokenProvider()

    override private init() {
        super.init()
    }

    deinit {
        Debugger.deInit(self.classForCoder)
    }
}
