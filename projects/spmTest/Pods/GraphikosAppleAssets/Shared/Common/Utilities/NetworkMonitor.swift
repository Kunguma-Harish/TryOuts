//
//  NetworkMonitor.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 10/12/23.
//  Copyright © 2023 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
import Network

public class NetworkMonitor: NSObject {
    private var networkPath: Any?
    private var pathMonitor: Any?

    private final let networkMonitorQueue = DispatchQueue(
        label: "com.zoho.show.graphikosAppleAssets.networkMonitorQueue"
    )

    static let shared = NetworkMonitor()

    var isNetworkAvailable: Bool {
        self.currentPath?.status == .satisfied
    }

    override private init() {
        super.init()
    }

    deinit {
        Debugger.deInit(self.classForCoder)
    }
}

@available(iOS 12.0, *)
public extension NetworkMonitor {
    static func startMonitoring() {
        self.shared.configureNetworkMonitor()
    }

    static func stopMonitoring() {
        self.shared.currentPathMonitor?.cancel()
    }
}

@available(iOS 12.0, *)
private extension NetworkMonitor {
    var currentPath: NWPath? {
        self.networkPath as? NWPath
    }

    var currentPathMonitor: NWPathMonitor? {
        self.pathMonitor as? NWPathMonitor
    }

    func configureNetworkMonitor() {
        let pathMonitor = NWPathMonitor()
        pathMonitor.pathUpdateHandler = { [weak self] path in
            self?.networkPath = path
        }
        pathMonitor.start(queue: self.networkMonitorQueue)
        self.pathMonitor = pathMonitor
    }
}
