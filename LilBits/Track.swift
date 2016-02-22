//
//  Track.swift
//  LilBits
//
//  Created by Mark Anderson on 2/19/16.
//  Copyright © 2016 markmakingmusic. All rights reserved.
//

import Foundation
import AVFoundation

// A struct that defines constants from a track object returned from the EarBits API. This is a lightweight version of the
// JSON dictionary returned from a typical request.

struct Track: Equatable {
    var trackId = ""
    var name = ""
    var artistName = ""
    var mediaFile = ""
    var coverImage = ""

    private struct Constants {
        static let trackId = "track_id"
        static let name = "name"
        static let artistName = "artist_name"
        static let mediaFile = "media_file"
        static let coverImage = "cover_image"
    }

    func toItem() -> AVPlayerItem {
        return AVPlayerItem(URL: NSURL(string: self.mediaFile)!)
    }

    init(dict: [String: AnyObject]) {
        if let trackId = dict[Constants.trackId] where trackId is String { self.trackId = String(trackId) }
        if let name = dict[Constants.name] where name is String { self.name = String(name) }
        if let artistName = dict[Constants.artistName] where artistName is String { self.artistName = String(artistName) }
        if let mediaFile = dict[Constants.mediaFile] where mediaFile is String { self.mediaFile = String(mediaFile) }
        if let coverImage = dict[Constants.coverImage] where coverImage is String { self.coverImage = String(coverImage) }
    }
}

func ==(lhs: Track, rhs: Track) -> Bool {
    return lhs.name == rhs.name
}
