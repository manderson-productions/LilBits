//
//  DownloadQueue.swift
//  LilBits
//
//  Created by Mark Anderson on 2/20/16.
//  Copyright © 2016 markmakingmusic. All rights reserved.
//

import Foundation

typealias DownloadQueueCallback = (success: Bool) -> (Void)
typealias OptionalTrackCallback = (track: Track?) -> (Void)

// The DownloadQueue class implements the Produceable protocol and initiates a download queue of 40 tracks once it is prompted
// for a track using the getNextTrack method.

class DownloadQueue: Produceable {

    // MARK: Properties

    private let maxQueueCount = 40
    private var tracks = [Track]()
    private var currentTrack: Track?
    static let sharedInstance = DownloadQueue()
    private let downloadQueue = dispatch_queue_create("com.manderson.LilBits.downoad-serial-queue", DISPATCH_QUEUE_SERIAL)

    // MARK: Private Methods

    private func fetchNext(didFinishLoadingTrack: DownloadQueueCallback? = nil) {
        dispatch_async(downloadQueue) { [weak self] in
            guard let strongself = self else { return }
            guard strongself.tracks.count < strongself.maxQueueCount else { return }

            NetworkTzar.request(.TrackJSON) { response in
                guard response.result.isSuccess else {
                    didFinishLoadingTrack?(success: false)
                    return
                }

                if let strongself = self, json = response.result.value {
                    let track = Track(dict: json as! [String : AnyObject])
                    strongself.tracks.append(track)
                }
                didFinishLoadingTrack?(success: true)
                strongself.fetchNext()
            }
        }
    }

    // MARK: Produceable

    func getNextTrack(completion: OptionalTrackCallback) {
        dispatch_async(downloadQueue) { [weak self] in
            guard let strongself = self else {
                completion(track: nil)
                return
            }

            if strongself.tracks.count == 0 {
                strongself.fetchNext { success in
                    if success {
                        strongself.getNextTrack(completion)
                    } else {
                        completion(track: nil)
                    }
                    return
                }
            } else if strongself.currentTrack == nil {
                strongself.currentTrack = strongself.tracks.first
            } else {
                if let index = strongself.tracks.indexOf(strongself.currentTrack!) where index < strongself.tracks.count {
                    strongself.currentTrack = strongself.tracks[index + 1]
                }
            }
            completion(track: strongself.currentTrack)
        }
    }

    func getPreviousTrack(completion: OptionalTrackCallback) {
        dispatch_async(downloadQueue) { [weak self] in
            guard let strongself = self else {
                completion(track: nil)
                return
            }
            guard strongself.currentTrack != nil else {
                completion(track: nil)
                return
            }

            if let index = strongself.tracks.indexOf(strongself.currentTrack!) where index > 0 {
                strongself.currentTrack = strongself.tracks[index - 1]
            }
            completion(track: strongself.currentTrack)
        }
    }
}
