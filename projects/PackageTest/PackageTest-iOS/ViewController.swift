//
//  ViewController.swift
//  PackageTest-iOS
//
//  Created by kunguma-14252 on 03/07/24.
//

import Foundation
import SSOKit
import UIKit
import Whiteboard
import Whiteboard_iOS

class ViewController: BaseViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if wbController == nil {
            updateActionButtons()
        }
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.updateConstraint()
        })
    }

    override func embedView(of wbRootController: WBViewController) {
        view.backgroundColor = .gray
        wbRootController.view.clipsToBounds = true
        wbContainerView.addSubview(wbRootController.view)
        wbContainerView.sendSubviewToBack(wbRootController.view)
        super.embedView(of: wbRootController)
    }

    override func presentSignInScreen() {
        Dependencies.authenticator.presentSignInScreen { [weak self] token, error in
            if let error = error as? NSError {
                if error.code != k_SSOSFSafariDismissedError {
                    Debugger.error("Authentication failure - \(error) - \(#function)")
                }
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


class Authenticator: BaseAuthenticator {
    private final let buildType: SSOBuildType = .Live_SSO

    override var currentUserZUID: String? {
        ZSSOKit.getCurrentUser().userZUID
    }

    override var isUserSignedIn: Bool {
        ZSSOKit.isUserSignedIn()
    }

    override func getAuthToken(handler: @escaping (String?, Int64, Error?) -> Void) {
        ZSSOKit.getOAuth2Token { token, miliseconde, error in
            handler(token, miliseconde, error)
        }
    }

    override func getMDMTokenFromSSO() -> String? {
        ZSSOKit.getMangedMDMToken()
    }

    override func getDeviceIDFromSSO() -> String? {
        ZIAMUtil.shared().getDeviceIDFromKeychain()
    }

    deinit {
        Debugger.deInit(self.classForCoder)
    }
}

extension Authenticator {
    func initialize(with window: UIWindow?) {
        ZSSOKit.clearSSODetailsForFirstLaunch()
        ZSSOKit.initWithClientID(
            clientId,
            scope: scopes,
            urlScheme: urlScheme,
            mainWindow: window,
            buildType: self.buildType
        )
        ZSSOKit.donotFetchProfilePhotoDuringSignin()
    }

    func presentSignInScreen(handler: @escaping ((String?, Error?) -> Void)) {
        ZSSOKit.presentInitialViewController { token, error in
            if token != nil {
                self.setIsUserSignedIn(signedIn: true)
            }
            handler(token, error)
        }
    }

    func signOut(handler: @escaping ((Error?) -> Void)) {
        ZSSOKit.revokeAccessToken { error in
            self.setIsUserSignedIn(signedIn: false)
            handler(error)
        }
    }

    func handle(url: URL, sourceApplication: String, annotation: Any) {
        ZSSOKit.handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }

    @available(iOS 13.0, *) func handle(urlContext: UIOpenURLContext) {
        ZSSOKit.handle(
            urlContext.url,
            sourceApplication: urlContext.options.sourceApplication,
            annotation: urlContext.options.annotation
        )
    }

    func logout(completionBlock: @escaping () -> Void) {
        ZSSOKit.revokeAccessToken { [weak self] error in
            self?.handleLogOutCompletion(error, completionBlock)
        }
    }
}
