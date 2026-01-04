//
//  PortionField+String.swift
//  Painter
//
//  Created by Sarath Kumar G on 02/12/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
import Proto

extension PortionField.FontWeight {
	/// StyleID for fontWeight
	var styleId: String {
		switch self {
		case .thin:
			return "100"
		case .extraLight:
			return "200"
		case .light:
			return "300"
		case .normal:
			return "400"
		case .medium:
			return "500"
		case .demiBold:
			return "600"
		case .bold:
			return "700"
		case .heavy:
			return "800"
		case .black:
			return "900"
		}
	}
}

extension PortionField.DateTimeField {
	/// Custom formatted Date string
	var formattedDate: String {
		let format = DateFormatter()

		switch self {
		case .format1:
			format.dateFormat = "M/dd/yyyy"
		case .format2:
			format.dateFormat = "EEEE, MMMM dd, yyyy"
		case .format3:
			format.dateFormat = "dd MMMM yyyy"
		case .format4:
			format.dateFormat = "MMMM dd, yyyy"
		case .format5:
			format.dateFormat = "dd-MMM-yy"
		case .format6:
			format.dateFormat = "MMMM yy"
		case .format7:
			format.dateFormat = "MMM yy"
		case .format8:
			format.dateFormat = "M/dd/yyyy hh:mm a"
			format.amSymbol = "AM"
			format.pmSymbol = "PM"
		case .format9:
			format.dateFormat = "M/dd/yyyy hh:mm:ss a"
			format.amSymbol = "AM"
			format.pmSymbol = "PM"
		case .format10:
			format.dateFormat = "hh:mm"
		case .format11:
			format.dateFormat = "hh:mm:ss"
		case .format12:
			format.dateFormat = "hh:mm a"
			format.amSymbol = "AM"
			format.pmSymbol = "PM"
		case .format13:
			format.dateFormat = "hh:mm:ss a"
			format.amSymbol = "AM"
			format.pmSymbol = "PM"
		case .format14:
			format.dateFormat = "yyyy/M/dd"
		case .format15:
			let timeZone = TimeZone(abbreviation: "JST")
			format.timeZone = timeZone
			format.dateFormat = "yyyy/M/dd"
		case .defDateTimeFieldFormat:
			// Using 'format1' for now; handle appropriately in future
			format.dateFormat = "M/dd/yyyy"
		}

		return format.string(from: Date())
	}
}
