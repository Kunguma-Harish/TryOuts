//
//  ViewController.swift
//  PackageTest
//
//  Created by kunguma-14252 on 12/06/24.
//

import AppKit
import Foundation
import Helper
import Whiteboard
import Whiteboard_Mac
import ZMacAuth

class ViewController: BaseViewController {
    override func viewWillAppear() {
        super.viewWillAppear()
        updateActionButtons()
        addNotificationObservers()
    }

    @objc func WindowDidResizing() {
        self.updateConstraint()
    }

    override func embedView(of wbRootController: WBViewController) {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.gray.cgColor
        wbRootController.view.layer?.masksToBounds = true
        wbContainerView.addSubview(
            wbRootController.view,
            positioned: .below,
            relativeTo: nil
        )
        super.embedView(of: wbRootController)
    }

    override func presentSignInScreen() {
        Dependencies.authenticator.presentSignInScreen(
            in: self.view
        ) { [weak self] token, error in
            if let error = error {
                Debugger.error("Authentication failure - \(error) - \(#function)")
                return
            }
            if token != nil {
                DispatchQueue.main.async {
                    self?.signinCompletionHandler(success: true)
                }
            }
        }
    }

    deinit {
        Debugger.deInit(self.classForCoder)
    }
}

@objc
private extension ViewController {
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.WindowDidResizing),
            name: NSNotification.Name("WindowDidResizing"),
            object: nil
        )
    }
}

class WindowController: NSWindowController {
    deinit {
        Debugger.deInit(self.classForCoder)
    }
}

extension WindowController: NSWindowDelegate {
    func windowDidResize(_: Notification) {
        Debugger.debug("Window did resize")
        NotificationCenter.default.post(
            name: NSNotification.Name("WindowDidResizing"),
            object: nil
        )
    }

    func windowDidEndLiveResize(_: Notification) {
        Debugger.debug("Window did end live resize")
        NotificationCenter.default.post(
            name: NSNotification.Name("WindowDidResizing"),
            object: nil
        )
    }
}

class Authenticator: BaseAuthenticator {
    private final let buildType: ZMacAuthBuildType = .Live_ZMacAuth

    override var currentUserZUID: String? {
        guard let currentUser = ZMacAuth.getCurrentUser() else {
            fatalError("Current logged in user unavailable - \(#function)")
        }
        return currentUser.userZUID
    }

    override func getAuthToken(handler: @escaping (String?, Int64, Error?) -> Void) {
        ZMacAuth.getOAuth2Token { accessToken, error in
            handler(accessToken, 0, error)
        }
    }

    override func getMDMTokenFromSSO() -> String? {
        nil
    }

    override func getDeviceIDFromSSO() -> String? {
        nil
    }

    deinit {
        Debugger.deInit(self.classForCoder)
    }
}

extension Authenticator {
    func initialize() {
        ZMacAuth.initWithClientID(
            clientId,
            scope: scopes,
            urlScheme: urlScheme,
            buildType: self.buildType
        )
    }

    func presentSignInScreen(
        in container: NSView,
        handler: @escaping ((String?, Error?) -> Void)
    ) {
        ZMacAuth.presentInitialViewController(
            inContentView: container
        ) { token, error in
            guard let token = token else {
                handler(token, error)
                print("loginFailed dueto: \(error.debugDescription)")
                return
            }
            self.setIsUserSignedIn(signedIn: true)
            handler(token, error)
        }
    }

    func logout(completionBlock: @escaping () -> Void) {
        ZMacAuth.revokeAccessToken { [weak self] error in
            self?.handleLogOutCompletion(error, completionBlock)
        }
    }
}
