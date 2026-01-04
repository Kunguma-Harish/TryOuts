//
//  FileManager+OnDemandResources.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 08/09/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

public extension FileManager {
    var texturesDirectory: URL? {
        ResourceBundleType.textures.resourceURL
    }
}
