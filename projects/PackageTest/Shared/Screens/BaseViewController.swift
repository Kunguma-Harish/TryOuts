//
//  BaseViewController.swift
//  PackageTest
//
//  Created by kunguma-14252 on 03/07/24.
//

import Foundation
import Whiteboard

class BaseViewController: PlatformViewController {
    // MARK: - IBOutlets

    @IBOutlet private var signinButton: PlatformButton!
    @IBOutlet private var loadWBButton: PlatformButton!
    @IBOutlet private(set) var wbContainerView: PlatformView!
    @IBOutlet weak var signOutButton: PlatformButton!

    // MARK: - Properties

    private var heightConstraint: PlatformLayoutConstraint?
    private var widthConstraint: PlatformLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateActionButtons()
    }

    func presentSignInScreen() {
        fatalError("Must be implemented by inheriting class")
    }

    func embedView(of wbRootController: WBViewController) {
        addChild(wbRootController)
        wbRootController.view.translatesAutoresizingMaskIntoConstraints = false
        let containerSize = WBViewController.containerSize(
            parent: self.wbContainerView.bounds
        )
        let widthLC = wbRootController.view.widthAnchor.constraint(
            equalToConstant: containerSize.width
        )
        let heightLC = wbRootController.view.heightAnchor.constraint(
            equalToConstant: containerSize.height
        )
        self.widthConstraint = widthLC
        self.heightConstraint = heightLC
        PlatformLayoutConstraint.activate(
            [
                widthLC,
                heightLC,
                wbRootController.view.centerYAnchor.constraint(
                    equalTo: self.wbContainerView.centerYAnchor
                ),
                wbRootController.view.centerXAnchor.constraint(
                    equalTo: self.wbContainerView.centerXAnchor
                )
            ]
        )
    }

    deinit {
        Debugger.deInit(self.classForCoder)
    }
}

// MARK: - IBActions

private extension BaseViewController {
    @IBAction func signinButtonAction(_: Any) {
        self.signinButton.isEnabled = true
        self.presentSignInScreen()
    }

    @IBAction func closeButtonAction(_: Any) {
        closeWhiteBoard()
    }

    @IBAction func loadWBButtonAction(_: Any) {
        loadWhiteBoard()
    }

    @IBAction func handleSignOutButtonTap(_: PlatformButton) {
        Dependencies.authenticator.logout { [weak self] in
            DispatchQueue.main.async {
                self?.updateActionButtons()
            }
        }
    }
}

extension BaseViewController {
    var wbController: WBViewController? {
        children.first { vc in
            vc is WBViewController
        } as? WBViewController
    }

    func updateConstraint() {
        let containerSize = WBViewController.containerSize(parent: self.wbContainerView.bounds)
        self.heightConstraint?.constant = containerSize.height
        self.widthConstraint?.constant = containerSize.width
        #if os(iOS)
            view.layoutIfNeeded()
        #elseif os(macOS)
            view.layout()
        #endif
        self.wbController?.setNeedsRefresh()
    }

    func signinCompletionHandler(success _: Bool) {
        self.signinButton.isEnabled = true
        self.updateActionButtons()
    }

    func updateActionButtons(isHidden: Bool? = nil) {
        guard self.wbController == nil else {
            return
        }
        let isUserSignedIn = Dependencies.authenticator.isUserSignedIn
        self.signinButton.isHidden = isHidden ?? isUserSignedIn
        self.loadWBButton.isHidden = isHidden ?? !isUserSignedIn
        self.signOutButton.isHidden = isHidden ?? !isUserSignedIn
    }
}

private extension BaseViewController {
    func closeWhiteBoard() {
        self.wbContainerView.isHidden = true
        self.wbController?.view.removeFromSuperview()
        self.wbController?.removeFromParent()
        self.updateActionButtons()
    }

    func loadWhiteBoard(asChildView: Bool = true) {
        self.wbContainerView.isHidden = false
        self.updateActionButtons(isHidden: true)

        let authenticator = Dependencies.authenticator
        if let wbRootController = WBViewController.rootViewController(
            resourceId: DocumentIdProvider.documentId,
            integType: authenticator.wbIntegType,
            authenticator: authenticator,
            tokenProvider: Dependencies.tokenProvider
        ) {
            if asChildView { // Adds "wbRootController" as a child to "ViewController"
                self.embedView(of: wbRootController)
            } else { // Presents the controller
                #if os(iOS)
                    present(wbRootController, animated: true)
                #elseif os(macOS)
                    presentAsSheet(wbRootController)
                #endif
            }
        }
    }
}
