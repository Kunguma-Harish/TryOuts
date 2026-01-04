//
//  AppDelegate.swift
//  PackageTest
//
//  Created by kunguma-14252 on 12/06/24.
//
//

import Cocoa
import Whiteboard


@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        configureAppLaunch()
    }

    func applicationSupportsSecureRestorableState(_: NSApplication) -> Bool {
        true
    }

    deinit {
        Debugger.deInit(self.classForCoder)
    }
}

private extension AppDelegate {
    func configureAppLaunch() {
        Dependencies.authenticator.initialize()
    }
}
