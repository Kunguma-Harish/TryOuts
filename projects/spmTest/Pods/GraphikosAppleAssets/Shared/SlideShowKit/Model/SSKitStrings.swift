//
//  SSKitStrings.swift
//  GraphikosAppleAssets
//
//  Created by magesh-5601 on 14/10/22.
//  Copyright © 2022 Zoho Corporation Pvt. Ltd. All rights reserved.
//

public enum SSKitStrings {
    public enum SlideShow: String, SSKLocalizable {
        case start = "SSKit.slideshow.start"
        case end = "SSKit.slideshow.end"
        case currentSlide = "SSKit.slideshow.currentSlide"
        case endOfSlideshow = "SSKit.slideshow.EndOfSlideshow"
        case blackout = "SSKit.slideshow.blackout"
        case clear = "SSKit.slideshow.clear"
        case emptyNotes = "SSKit.slideshow.emptyNotes"
    }

    public enum MCPeerListing: String, SSKLocalizable {
        case chooseAppleTVS = "SSKit.mcPeerListing.chooseAppleTVS"
        case lookingForTvs = "SSKit.mcPeerListing.lookingForTvs"
        case updateError = "SSKit.mcPeerListing.updateError"

        public enum Disconnect: String, SSKLocalizable {
            case title = "SSKit.mcPeerListing.disconnect.title"
            case nameSuffix = "SSKit.mcPeerListing.disconnect.nameSuffix"
            case message = "SSKit.mcPeerListing.disconnect.message"
        }
    }

    public enum Common: String, SSKLocalizable {
        case ok = "SSKit.common.ok"
        case cancel = "SSKit.common.cancel"
        case `continue` = "SSKit.common.continue"
        case untitledDocument = "SSKit.common.untitledDocument"
        case noNetwork = "SSKit.common.noNetwork"
        case noNetworkMessage = "SSKit.common.noNetworkMessage"
        case connected = "SSKit.common.connected"
        case connecting = "SSKit.common.connecting"
        case waiting = "SSKit.common.waiting"
        case update = "SSKit.common.update"
    }

    public enum SharePlay: String, SSKLocalizable {
        case sessionTerminatedTitle = "SSKit.shareplay.sessionTerminated.title"
        case sessionTerminatedDesc = "SSKit.shareplay.sessionTerminated.desc"

        public enum End: String, SSKLocalizable {
            case title = "SSKit.shareplay.end.title"
            case description = "SSKit.shareplay.end.description"
        }
    }

    public enum Error: String, SSKLocalizable {
        case title = "SSKit.error.title"
        case message = "SSKit.error.message"
    }

    public enum PlaybackAudio: String, SSKLocalizable {
        case playbackAudio = "SSKit.audio.playbackAudio"
        case pause = "SSKit.audio.pause"
        case resume = "SSKit.audio.resume"
    }
}
