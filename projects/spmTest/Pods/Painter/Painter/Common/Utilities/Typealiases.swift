//
//  Typealiases.swift
//  Painter
//
//  Created by Sarath Kumar G on 11/08/21.
//  Copyright © 2021 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if !os(watchOS)
#if os(macOS)
import Cocoa

public typealias PlatformTextViewDelegate = NSTextViewDelegate
public typealias PlatformTextView = NSTextView
public typealias PlatformTextGranularity = NSSelectionGranularity
public typealias PlatformMenuItem = NSMenuItem
typealias PlatformFontDescriptor = NSFontDescriptor
#else
import CoreGraphics
import UIKit

public typealias PlatformTextViewDelegate = UITextViewDelegate
public typealias PlatformTextView = UITextView
public typealias PlatformTextGranularity = UITextGranularity
#if !os(tvOS)
public typealias PlatformMenuItem = UIMenuItem
#endif
typealias PlatformFontDescriptor = UIFontDescriptor
#endif
#endif
