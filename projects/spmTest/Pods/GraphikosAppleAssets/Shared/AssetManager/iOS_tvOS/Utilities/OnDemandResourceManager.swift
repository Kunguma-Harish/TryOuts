//
//  OnDemandResourceManager.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 08/09/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

public class OnDemandResourceManager: NSObject {
    public static let shared = OnDemandResourceManager()

    private final let resourceLoadingPriority = 0.5

    private var currentRequests: [NSBundleResourceRequest] = []

    override private init() {
        super.init()
    }

    deinit {
        Debugger.deInit(self.classForCoder)
    }
}

public extension OnDemandResourceManager {
    func fetchResources(ofTypes resourceTypes: [ResourceBundleType]) async throws {
        let tags = Set(resourceTypes.map(\.rawValue))

        guard
            !self.currentRequests.contains(
                where: { bundleRequest in
                    !bundleRequest.tags.isDisjoint(with: tags)
                }
            )
        else {
            return
        }
        let newRequest = NSBundleResourceRequest(tags: tags)
        newRequest.loadingPriority = self.resourceLoadingPriority
        self.currentRequests.append(newRequest)

        guard await !newRequest.conditionallyBeginAccessingResources() else {
            return
        }
        do {
            try await newRequest.beginAccessingResources()
        } catch {
            throw error
        }
    }
}
