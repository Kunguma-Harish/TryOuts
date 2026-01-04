//
//  AssetImageTypes_macOS.swift
//  Show-macOS
//
//  Created by harish-13272 on 18/08/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import AppKit

public enum AnimationImageType: AssetImageTypeRepresentable {
    case curveIcon
    case custom
    case lineIcon
    case squigglesIcon

    public func getImage(
        for _: AppThemeColorType,
        suffix: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> NSImage {
        switch self {
        case .curveIcon:
            return self.getImage(named: "Curve\(suffix)")
        case .lineIcon:
            return self.getImage(named: "Line\(suffix)")
        case .squigglesIcon:
            return self.getImage(named: "Squiggles\(suffix)")
        default:
            return self.getImage()
        }
    }
}

public enum CommonSFImageType: AssetImageTypeRepresentable {
    case text

    var systemSymbolName: String {
        switch self {
        case .text:
            "character.textbox"
        }
    }

    public func getImage(
        for _: AppThemeColorType,
        suffix _: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> PlatformImage {
        switch self {
        case .text:
            return self.getSFSymbol(
                named: self.systemSymbolName,
                symbolConfigurations: symbolConfigurations
            )
        }
    }
}

public enum ErrorImageType: AssetImageTypeRepresentable {
    case noAccessError
    case trashedPresentationError
}

public enum InsertChartSectionImageType: AssetImageTypeRepresentable {
    case areaChart
    case bars
    case columns
    case dougnuts
    case lines
    case pies
    case scatters

    var systemSymbolName: String? {
        switch self {
        case .bars:
            return "chart.bar.doc.horizontal"
        case .columns:
            return "chart.bar"
        case .dougnuts:
            return "circle.dashed"
        case .lines:
            return "chart.line.uptrend.xyaxis"
        case .pies:
            return "chart.pie"
        case .scatters:
            return "chart.dots.scatter"
        default:
            return nil
        }
    }

    public func getImage(
        for _: AppThemeColorType,
        suffix _: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> NSImage {
        if let systemSymbolName {
            return getSFSymbol(
                named: systemSymbolName,
                symbolConfigurations: symbolConfigurations
            )
        }
        return self.getImage()
    }
}

public enum InsertShapeImageType: AssetImageTypeRepresentable {
    case shape
    case silhouettes
    case smartElement

    var systemSymbolName: String? {
        switch self {
        case .shape:
            "square.on.circle"
        case .silhouettes:
            "figure.walk"
        default:
            nil
        }
    }

    public func getImage(
        for _: AppThemeColorType,
        suffix _: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> NSImage {
        if let systemSymbolName {
            return getSFSymbol(
                named: systemSymbolName,
                symbolConfigurations: symbolConfigurations
            )
        }
        return self.getImage()
    }
}

public enum InsertSymbolCategoryImageType: AssetImageTypeRepresentable {
    case arrow
    case currency
    case mathScience
    case miscellaneous
    case punctuations
}

public enum InsertShapeCategoryImageType: AssetImageTypeRepresentable {
    case basicShapes
    case blockArrows
    case flowCharts
    case equationShapes
    case stars
    case callouts
    case actionButtons
    case lines
}

public enum InsertSilhouttesSectionImageType: AssetImageTypeRepresentable {
    case emotions
    case business
    case handGestures
    case currencies
    case atheletes
}

public enum InsertTextSectionImageType: AssetImageTypeRepresentable {
    case symbols
    case dataFields

    var systemSymbolName: String {
        switch self {
        case .symbols:
            "sum"
        case .dataFields:
            "square.stack.3d.up.fill"
        }
    }

    public func getImage(
        for _: AppThemeColorType,
        suffix _: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> NSImage {
        getSFSymbol(
            named: self.systemSymbolName,
            symbolConfigurations: symbolConfigurations
        )
    }
}

public enum InsertMediaSectionImageType: AssetImageTypeRepresentable {
    case library
    case url
    case pexels
    case image
    case video
    case audio
    case info

    var systemSymbolName: String? {
        switch self {
        case .library:
            return "photo.on.rectangle.angled"
        case .url:
            return "link.circle"
        case .image:
            return "photo.stack"
        case .video:
            return "video"
        case .audio:
            return "mic"
        case .info:
            return "info.circle"
        default:
            return nil
        }
    }

    public func getImage(
        for _: AppThemeColorType,
        suffix _: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> NSImage {
        if let systemSymbolName {
            return getSFSymbol(
                named: systemSymbolName,
                symbolConfigurations: symbolConfigurations
            )
        }
        return self.getImage()
    }
}

public enum InsertAddonsSectionImageType: AssetImageTypeRepresentable {
    case humaaans
    case feather
    case twemoji
}

public enum InsertSymbolsImageType: AssetImageTypeRepresentable {
    case arrow
    case currency
    case mathScience
    case miscellaneous
    case punctuations

    var systemSymbolName: String? {
        switch self {
        case .arrow:
            return "arrow.right"
        case .currency:
            return "dollarsign"
        case .mathScience:
            return "plusminus"
        case .miscellaneous:
            return "sun.min"
        case .punctuations:
            return "at"
        }
    }

    public func getImage(
        for _: AppThemeColorType,
        suffix _: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> NSImage {
        if let systemSymbolName {
            return getSFSymbol(
                named: systemSymbolName,
                symbolConfigurations: symbolConfigurations
            )
        }
        return self.getImage()
    }
}

public enum ConnectorImageType: AssetImageTypeRepresentable, CaseIterable {
    case arrow
    case doubleArrow
    case elbowConnector
    case elbowArrowConnector
    case elbowDoubleArrowConnector
    case curvedConnector
    case curvedArrowConnector
    case curvedDoubleArrowConnector

    public func getImage(
        for _: AppThemeColorType,
        suffix _: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> NSImage {
        switch self {
        case .arrow:
            return self.getImage(named: "ARROW")
        case .doubleArrow:
            return self.getImage(named: "DOUBLE_ARROW")
        case .elbowConnector:
            return self.getImage(named: "ELBOW_CONNECTOR")
        case .elbowArrowConnector:
            return self.getImage(named: "ELBOW_ARROW_CONNECTOR")
        case .elbowDoubleArrowConnector:
            return self.getImage(named: "ELBOW_DOUBLE_ARROW_CONNECTOR")
        case .curvedConnector:
            return self.getImage(named: "CURVED_CONNECTOR")
        case .curvedArrowConnector:
            return self.getImage(named: "CURVED_ARROW_CONNECTOR")
        case .curvedDoubleArrowConnector:
            return self.getImage(named: "CURVED_DOUBLE_ARROW_CONNECTOR")
        }
    }
}

public enum CreateNewImageType: AssetImageTypeRepresentable {
    case slides
    case templates
    case themes
}

public enum FormatAnimateImageType: AssetImageTypeRepresentable {
    case emphasis
    case entry
    case exit
    case path
}

public enum FormatImageType: AssetImageTypeRepresentable {
    case noFill
    case noFillInsideCollection
}

public enum FormatShapeImageType: AssetImageTypeRepresentable {
    case lEndPointIcon
    case lPointSizeIcon
    case rEndPointIcon
    case rPointSizeIcon

    public func getImage(
        for _: AppThemeColorType,
        suffix: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> NSImage {
        switch self {
        case .lEndPointIcon:
            return self.getImage(named: "lEndPoint\(suffix)")
        case .lPointSizeIcon:
            return self.getImage(named: "lPointSize\(suffix)")
        case .rEndPointIcon:
            return self.getImage(named: "rEndPoint\(suffix)")
        case .rPointSizeIcon:
            return self.getImage(named: "rPointSize\(suffix)")
        }
    }
}

public enum FormatStyleImageType: AssetImageTypeRepresentable {
    case innerIcon
    case outerIcon
    case reflectionIcon
    case innerIconSelected
    case outerIconSelected
    case reflectionIconSelected

    public func getImage(
        for _: AppThemeColorType,
        suffix: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> NSImage {
        switch self {
        case .innerIcon:
            return self.getImage(named: "inner\(suffix)")
        case .outerIcon:
            return self.getImage(named: "outer\(suffix)")
        case .reflectionIcon:
            return self.getImage(named: "reflection\(suffix)")
        case .innerIconSelected:
            return self.getImage(named: "inner\(suffix)Selected")
        case .outerIconSelected:
            return self.getImage(named: "outer\(suffix)Selected")
        case .reflectionIconSelected:
            return self.getImage(named: "reflection\(suffix)_selected")
        }
    }
}

public enum FormatTableImageType: AssetImageTypeRepresentable {
    case columnSelector
    case remove
    case rowSelector
    case columnLeft
    case columnRight
    case rowTop
    case rowBottom
}

public enum FormatListStyleImageType: AssetImageTypeRepresentable {
    case charBulletIcon
    case numBulletIcon

    public func getImage(
        for _: AppThemeColorType,
        suffix: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> NSImage {
        switch self {
        case .charBulletIcon:
            return self.getImage(named: "charBullet\(suffix)")
        case .numBulletIcon:
            return self.getImage(named: "numBullet\(suffix)")
        }
    }
}

public enum FormatTextImageType: AssetImageTypeRepresentable {
    case textIndentLeftSelected
    case textIndentRightSelected
    case textIndentLeftUnSelected
    case textIndentRightUnSelected
}

public enum InsertChartImageType: AssetImageTypeRepresentable {
    case coloumnIcon
    case barIcon
    case lineIcon
    case scatterIcon
    case pieIcon
    case areaIcon
    case othersIcon

    public func getImage(
        for _: AppThemeColorType,
        suffix: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> NSImage {
        switch self {
        case .coloumnIcon:
            return self.getImage(named: "Coloumn-\(suffix)")
        case .barIcon:
            return self.getImage(named: "Bar-\(suffix)")
        case .lineIcon:
            return self.getImage(named: "Line-\(suffix)")
        case .scatterIcon:
            return self.getImage(named: "Scatter-\(suffix)")
        case .pieIcon:
            return self.getImage(named: "Pie-\(suffix)")
        case .areaIcon:
            return self.getImage(named: "Area-\(suffix)")
        case .othersIcon:
            return self.getImage(named: "Others-\(suffix)")
        }
    }
}

public enum InsertSilhouettesImageType: AssetImageTypeRepresentable {
    case businessIcon
    case athletesIcon
    case emotionsIcon
    case handGesturesIcon
    case currenciesIcon

    public func getImage(
        for _: AppThemeColorType,
        suffix: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> NSImage {
        switch self {
        case .businessIcon:
            return self.getImage(named: "Business-\(suffix)")
        case .athletesIcon:
            return self.getImage(named: "Athletes-\(suffix)")
        case .emotionsIcon:
            return self.getImage(named: "Emotions-\(suffix)")
        case .handGesturesIcon:
            return self.getImage(named: "HandGestures-\(suffix)")
        case .currenciesIcon:
            return self.getImage(named: "Currencies-\(suffix)")
        }
    }
}

public enum InsertTableImageType: AssetImageTypeRepresentable {
    case tableIcon

    public func getImage(
        for _: AppThemeColorType,
        suffix: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> NSImage {
        switch self {
        case .tableIcon:
            return self.getImage(named: "table-\(suffix)")
        }
    }
}

public enum ListingImageType: AssetImageTypeRepresentable {
    case grid
    case list
    case notification
    case offline
    case paused
    case saveOffline
    case searchNotFound
}

public enum ListingFilterImageType: AssetImageTypeRepresentable {
    case offlineFilter
    case ownedFilter
    case recentFilter
    case sharedFilter
    case slidesFilter
    case templatesFilter
    case themesFilter
    case trashedFilter
}

public enum PlaceholderImageType: AssetImageTypeRepresentable {
    case chartPlaceHolder
    case createdByMePlaceHolder
    case galleryPlaceHolder
    case mediaPlaceHolder
    case notificationPlaceHolder
    case offlinePresentationPlaceHolder
    case recentsPlaceHolder
    case searchPlaceHolder
    case sharedWithMePlaceHolder
    case slideImagePlaceHolder
    case tablePlaceHolder
    case thumbnailPlaceHolder
    case trashPlaceHolder
    case userPlaceHolder
    case pexelsImagePlaceHolder
    case pexelsVideoPlaceHolder
    case twemojiErrorPlaceHolder
    case libraryImagePlaceHolder
    case libraryVideoPlaceHolder
    case libraryAudioPlaceHolder
    case dataFieldsPlaceHolder
    case emptySearchPlaceHolder
}

public enum SlideShowImageType: AssetImageTypeRepresentable {
    case embedVideoThumbnail
}

public enum ToolBarImageType: AssetImageTypeRepresentable {
    case animate
    case format
    case review
    case redo
    case undo
    case share
    case insert
    case shape
    case media
    case table
    case chart
    case addons
    case sideBarToggle
    case present
    case dataArt

    var systemSymbolName: String? {
        switch self {
        case .animate:
            return "square.stack.3d.forward.dottedline"
        case .format:
            return "paintbrush"
        case .review:
            return "text.bubble"
        case .insert:
            return "plus.rectangle"
        case .sideBarToggle:
            return "sidebar.left"
        case .undo:
            return "arrow.uturn.backward"
        case .redo:
            return "arrow.uturn.forward"
        case .shape:
            return "square.on.circle"
        case .media:
            return "photo"
        case .table:
            return "table"
        case .chart:
            return "chart.pie"
        case .addons:
            return "puzzlepiece.extension"
        case .share:
            return "square.and.arrow.up"
        case .present:
            return "play.fill"
        default:
            return nil
        }
    }

    public func getImage(
        for _: AppThemeColorType,
        suffix _: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> NSImage {
        if let systemSymbolName {
            return getSFSymbol(
                named: systemSymbolName,
                symbolConfigurations: symbolConfigurations
            )
        }
        return self.getImage()
    }
}

public enum CursorImageType: AssetImageTypeRepresentable {
    case fourPointCursor
    case diagonal1
    case diagonal2
    case rightLeft
    case topBottom
    case rotate
    case modifier
}

public enum CommonFormatImageType: AssetImageTypeRepresentable {
    case downArrow
    case downArrowSmall
}
