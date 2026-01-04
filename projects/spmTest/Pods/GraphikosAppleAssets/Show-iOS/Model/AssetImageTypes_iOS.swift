//
//  AssetImageTypes_iOS.swift
//  Show-iOS
//
//  Created by Sarath Kumar G on 21/07/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import UIKit

public enum AnimationImageType: AssetImageTypeRepresentable {
    case curveIcon
    case custom
    case edit
    case lineIcon
    case previewAll
    case squigglesIcon
    case stop

    public func getImage(
        for _: AppThemeColorType,
        suffix: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> UIImage {
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

public enum BottomBarImageType: AssetImageTypeRepresentable {
    case animateIcon
    case formatIcon
    case reviewIcon
    case tvListWarning

    public func getImage(
        for themeType: AppThemeColorType,
        suffix _: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> UIImage {
        switch self {
        case .animateIcon:
            return self.getImage(named: "animate_\(themeType)")
        case .formatIcon:
            return self.getImage(named: "format_\(themeType)")
        case .reviewIcon:
            return self.getImage(named: "review_\(themeType)")
        default:
            return self.getImage()
        }
    }
}

public enum CommentImageType: AssetImageTypeRepresentable {
    case addNewComments
    case archive
    case close
    case commentDelete
    case commentEdit
    case open
}

public enum InsertSymbolsImageType: AssetImageTypeRepresentable {
    case arrow
    case currency
    case mathScience
    case miscellaneous
    case punctuations
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
    ) -> UIImage {
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

public enum EditorImageType: AssetImageTypeRepresentable {
    case insertSlideWhite
    case newSlideIcon
    case sidebar
    case sidebarWhite

    public func getImage(
        for themeType: AppThemeColorType,
        suffix _: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> UIImage {
        switch self {
        case .newSlideIcon:
            return self.getImage(named: "newSlide_\(themeType)")
        default:
            return self.getImage()
        }
    }
}

public enum ErrorImageType: AssetImageTypeRepresentable {
    case noAccessError
    case trashedPresentationError
}

public enum FormatAnimateImageType: AssetImageTypeRepresentable {
    case emphasis
    case entry
    case exit
    case path
}

public enum FormatChartImageType: AssetImageTypeRepresentable {
    case chartEditLeftChevron
    case chartEditRightChevron
}

public enum FormatFillImageType: AssetImageTypeRepresentable {
    case gradientFill
    case gradientFillActive
    case imageFill
    case imageFillActive
    case patternsFill
    case patternFillActive
    case solidFill
    case solidFillActive
}

public enum FormatShapeImageType: AssetImageTypeRepresentable {
    case lEndPointIcon
    case lPointSizeIcon
    case rEndPointIcon
    case rPointSizeIcon
    case smartPreview

    public func getImage(
        for _: AppThemeColorType,
        suffix: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> UIImage {
        switch self {
        case .lEndPointIcon:
            return self.getImage(named: "lEndPoint\(suffix)")
        case .lPointSizeIcon:
            return self.getImage(named: "lPointSize\(suffix)")
        case .rEndPointIcon:
            return self.getImage(named: "rEndPoint\(suffix)")
        case .rPointSizeIcon:
            return self.getImage(named: "rPointSize\(suffix)")
        default:
            return self.getImage()
        }
    }
}

public enum FormatStyleImageType: AssetImageTypeRepresentable {
    case crop
    case cropToShapeIcon
    case innerIcon
    case outerIcon
    case tick
    case tickGray
    case tickMark
    case unSelectedCheckBox

    public func getImage(
        for themeType: AppThemeColorType,
        suffix: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> UIImage {
        switch self {
        case .cropToShapeIcon:
            return self.getImage(named: "cropToShape_\(themeType)")
        case .innerIcon:
            return self.getImage(named: "inner\(suffix)")
        case .outerIcon:
            return self.getImage(named: "outer\(suffix)")
        default:
            return self.getImage()
        }
    }
}

public enum FormatTableImageType: AssetImageTypeRepresentable {
    case columnSelector
    case remove
    case rowSelector
    case rowTop
    case rowBottom
    case columnLeft
    case columnRight
    case horizontal
    case vertical

    public func getImage(
        for themeType: AppThemeColorType,
        suffix _: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> UIImage {
        switch self {
        case .columnLeft, .columnRight, .rowBottom, .rowTop:
            return self.getSFSymbol(named: "\(String(describing: self))", symbolConfigurations: symbolConfigurations)
        case .horizontal, .vertical:
            return self.getImage(named: "\(String(describing: self))_\(themeType)")
        default:
            return self.getImage()
        }
    }
}

public enum FormatTextImageType: AssetImageTypeRepresentable {
    case aMinus
    case aPlus
    case charBulletIcon
    case hideKeyboard
    case numBulletIcon
    case textBold
    case textItalic
    case textIndentDisabledLeftIcon
    case textIndentDisabledRightIcon
    case textIndentLeftIcon
    case textIndentRightIcon
    case textStrike
    case textUnderline

    var systemSymbolName: String? {
        switch self {
        case .textBold:
            return "bold"
        case .textItalic:
            return "italic"
        case .textUnderline:
            return "underline"
        case .textStrike:
            return "strikethrough"
        default:
            return nil
        }
    }

    public func getImage(
        for themeType: AppThemeColorType,
        suffix: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> UIImage {
        if let systemSymbolName {
            return getSFSymbol(
                named: systemSymbolName,
                symbolConfigurations: symbolConfigurations
            )
        }
        switch self {
        case .charBulletIcon:
            return self.getImage(named: "charBullet\(suffix)")
        case .textIndentDisabledLeftIcon:
            return self.getImage(named: "textIndentDisabledLeft_\(themeType)")
        case .textIndentDisabledRightIcon:
            return self.getImage(named: "textIndentDisabledRight_\(themeType)")
        case .textIndentLeftIcon:
            return self.getImage(named: "textIndentLeft_\(themeType)")
        case .textIndentRightIcon:
            return self.getImage(named: "textIndentRight_\(themeType)")
        case .numBulletIcon:
            return self.getImage(named: "numBullet\(suffix)")
        default:
            return self.getImage()
        }
    }
}

public enum HelperImageType: AssetImageTypeRepresentable {
    case appIcon
    case decrease
    case increase
    case stepperBg
    case stepperBgActiveState

    public func getImage(
        for _: AppThemeColorType,
        suffix _: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> UIImage {
        switch self {
        case .appIcon:
            return self.getImage(named: "AppIcon")
        default:
            return self.getImage()
        }
    }
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
    ) -> UIImage {
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

public enum InsertImageType: AssetImageTypeRepresentable {
    case brokenLink
    case insertImageUrlPreview
    case secureLink
    case tbIcon
    case sort

    public func getImage(
        for _: AppThemeColorType,
        suffix: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> UIImage {
        switch self {
        case .sort:
            return self.getSFSymbol(
                named: "arrow.up.arrow.down.circle",
                symbolConfigurations: symbolConfigurations
            )
        case .tbIcon:
            return self.getImage(named: "TB\(suffix)")
        default:
            return self.getImage()
        }
    }
}

public enum InsertShapeGroupType: AssetImageTypeRepresentable {
    case addOns
    case shapes
    case silhoutte
    case smartElement
}

public enum InsertTextImageType: AssetImageTypeRepresentable {
    case dataField
    case symbol
    case quickInsert

    var systemSymbolName: String? {
        switch self {
        case .quickInsert:
            return "plus.circle"
        default:
            return nil
        }
    }

    public func getImage(
        for _: AppThemeColorType,
        suffix _: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> UIImage {
        if let systemSymbolName {
            return getSFSymbol(
                named: systemSymbolName,
                symbolConfigurations: symbolConfigurations
            )
        }
        return self.getImage()
    }
}

public enum InsertMediaImageType: AssetImageTypeRepresentable {
    case audio
    case camera
    case dailymotion
    case feather
    case files
    case humaaans
    case twemoji
    case imageGallery
    case imageLibrary
    case url
    case video
    case youtube
    case pexels
    case giphy
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
    ) -> UIImage {
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
    ) -> UIImage {
        switch self {
        case .tableIcon:
            return self.getImage(named: "table-\(suffix)")
        }
    }
}

public enum ListingImageType: AssetImageTypeRepresentable {
    case makeOffline
    case notification
    case newPresentationIcon
    case quickShare
    case offline
    case paused
    case saveOffline
    case removeOffline
    case rename
    case restore
    case sort
    case trash
    case copyLink
    case searchNotFound

    var systemSymbolName: String? {
        switch self {
        case .newPresentationIcon:
            return "plus.circle.fill"
        default:
            return nil
        }
    }

    public func getImage(
        for _: AppThemeColorType,
        suffix _: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> UIImage {
        if let systemSymbolName {
            return getSFSymbol(
                named: systemSymbolName,
                symbolConfigurations: symbolConfigurations
            )
        }
        return self.getImage()
    }
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

public enum NavBarImageType: AssetImageTypeRepresentable {
    case back
    case close
    case `import`
    case insert
    case keyboard
    case keyboardWithBG
    case previewStroke
    case redo
    case share
    case undo
}

public enum NotificationImageType: AssetImageTypeRepresentable {
    case checkMarkCircle

    var systemSymbolName: String? {
        switch self {
        case .checkMarkCircle:
            return "checkmark.circle"
        }
    }

    public func getImage(
        for _: AppThemeColorType,
        suffix _: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> UIImage {
        if let systemSymbolName {
            return getSFSymbol(
                named: systemSymbolName,
                symbolConfigurations: symbolConfigurations
            )
        }
        return self.getImage()
    }
}

public enum PlaceholderImageType: AssetImageTypeRepresentable {
    case chartPlaceHolder
    case chartPresetPlaceHolder
    case createdByMePlaceHolder
    case commentPlaceHolder
    case docs
    case galleryPlaceHolder
    case imagePlaceHolder
    case mediaPlaceHolder
    case noInternetPlaceHolder
    case importNonSignInPlaceHolder
    case notificationPlaceHolder
    case offlinePresentationPlaceHolder
    case recentsPlaceHolder
    case sharedWithMePlaceHolder
    case slideImagePlaceHolder
    case tablePlaceHolder
    case tablePresetPlaceHolder
    case thumbnailPlaceHolder
    case thumbnailPlaceHolderPortrait
    case transparentColorPattern
    case trashPlaceHolder
    case twemojiErrorPlaceHolder
    case libraryImagePlaceHolder
    case uploadAudioPlaceHolder
    case uploadVideoPlaceHolder
    case userPlaceHolder
    case workDrive
    case embedVideosListingPlaceHolder
    case emptyFeatherIconsPlaceHolder
    case dataFieldsPlaceHolder
    case pexelsImagePlaceHolder
    case multipleFill
    case highlightPlaceHolder
}

public enum QuickTextFormatImageType: AssetImageTypeRepresentable {
    case quickTextFormatIcon

    public func getImage(
        for themeType: AppThemeColorType,
        suffix _: String,
        symbolConfigurations _: [PlatformSymbolConfiguration]
    ) -> UIImage {
        switch self {
        case .quickTextFormatIcon:
            return self.getImage(named: "quick_text_format_\(themeType)")
        }
    }
}

public enum SettingImageType: AssetImageTypeRepresentable {
    case gear
    case profile
}

public enum ShareImageType: AssetImageTypeRepresentable {
    case copy
    case newUser
    case savePdf
    case savePptx
    case opaqueAppIcon
    case pdf
    case imageFormat

    var systemSymbolName: String? {
        switch self {
        case .pdf:
            return "doc.text.image"
        case .imageFormat:
            return "photo.fill"
        default:
            return nil
        }
    }

    public func getImage(
        for _: AppThemeColorType,
        suffix _: String,
        symbolConfigurations: [PlatformSymbolConfiguration]
    ) -> UIImage {
        if let systemSymbolName {
            return self.getSFSymbol(
                named: systemSymbolName,
                symbolConfigurations: symbolConfigurations
            )
        }
        return self.getImage()
    }
}

public enum SlideImageType: AssetImageTypeRepresentable {
    case glow
    case tickMark
}

public enum SlideShowImageType: AssetImageTypeRepresentable {
    case blackout
    case checkMarkSmall
    case closeSlideShow
    case closeToolBar
    case hidden
    case highlighter
    case live
    case notes
    case notesClose
    case penSelected
    case penUnselected
    case twitterPause
    case twitterPlay
    case embedVideoThumbnail
}

public enum LaunchImageType: AssetImageTypeRepresentable {
    case launchLogo
}

public enum EmptyLibraryMediaType: AssetImageTypeRepresentable {
    case emptyLibraryImage
    case emptyLibraryVideo
    case emptyLibraryAudio
}
