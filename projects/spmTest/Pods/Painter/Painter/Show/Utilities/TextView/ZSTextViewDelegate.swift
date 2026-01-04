//
//  ZSTextViewDelegate.swift
//  Painter
//
//  Created by Sarath Kumar G on 11/08/21.
//  Copyright © 2021 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

#if !os(watchOS)
public protocol ZSTextViewDelegate: PlatformTextViewDelegate {
#if os(macOS)
	// In macOS, 'esc' key can be used to exit editing.
	// When 'esc' is pressed, this method on the delegate will be invoked.
	func stopTextEditing()
	// In macOS, 'down' key can be used to change focus to DataFields SubView.
	// When 'down' key is pressed, this method on the delegate will be invoked.
	// The method returns a boolean if the down arrow action should be performed
	func downKeyPressed() -> Bool
	// In macOS, 'up' key can be used to change focus to DataFields SubView.
	// When 'up' key is pressed, this method on the delegate will be invoked.
	// The method returns a boolean if the up arrow action should be performed
	func upKeyPressed() -> Bool
	// In macOS, 'enter' key can be used to change focus to DataFields SubView.
	// When 'enter' key is pressed, this method on the delegate will be invoked.
	// The method returns a boolean if the up arrow action should be performed
	func enterKeyPressed() -> Bool
#else
	func openTextFormatMenu()
	func endFloatingCursor()
	func beginFloatingCursor()
	func openInsertSymbolContainer()
#endif
	func cutText()
	func copyText()
	func pasteText()
	func deleteText()

	func getFontId(forFamily familyName: String, withStyleId styleId: String) -> String?
	func resize(_ textView: ZSTextView)
}

#if !os(macOS)
public extension ZSTextViewDelegate {
	func endFloatingCursor() {}
	func beginFloatingCursor() {}
	func openInsertSymbolContainer() {}
}
#endif
#endif
