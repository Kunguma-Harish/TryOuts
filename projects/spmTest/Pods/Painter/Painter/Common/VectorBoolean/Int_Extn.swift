import CoreGraphics
import Foundation

public extension Int {
	/// Our utility extension to ease identification
	/// of places where we test for even numbers
	var isEven: Bool {
		return self % 2 == 0
	}

	/// Our utility extension to ease identification
	/// of places where we test for odd numbers
	var isOdd: Bool {
		return self % 2 == 1
	}
}
