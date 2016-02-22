//
//  Player.swift
//  LilBits
//
//  Created by Mark Anderson on 2/19/16.
//  Copyright © 2016 markmakingmusic. All rights reserved.
//

import Foundation
import AVFoundation

typealias PlayerControlStateCallback = (state: ControlState) -> (Void)
typealias PlayerTrackInfoCallback = (track: Track) -> (Void)

enum ControlState {
    case Playing, Paused, NextTrack, PreviousTrack
}

// The Player class controls the music playback and necessary fetching of new tracks. Control State change callbacks are
// implemented in order for the Player object owner to be notified of any changes to state. A serial queue is utilized to
// ensure any operations are occurring in a thread safe way.

class Player: NSObject, Playable {

    // MARK: Properties

    private var queue: AVQueuePlayer?
    private let serialQueue = dispatch_queue_create("com.manderson.LilBits.player-serial-queue", DISPATCH_QUEUE_SERIAL)
    private let didChangeControlState: PlayerControlStateCallback
    private let nextTrackBeganCallback: PlayerTrackInfoCallback

    // MARK: Init/ Deinit

    init(controlStateDidChange: PlayerControlStateCallback,
        nextTrackBeganCallback: PlayerTrackInfoCallback) {
            self.didChangeControlState = controlStateDidChange
            self.nextTrackBeganCallback = nextTrackBeganCallback

            super.init()

            self.next()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: Private Methods

    private func initializeQueue(item: AVPlayerItem) {
        queue = AVQueuePlayer(items: [item])
        queue!.actionAtItemEnd = .Advance
    }

    private func addObserverForQueueItem(item: AVPlayerItem) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("playerItemDidFinishPlaying:"),
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: item)
    }

    // MARK: Playable Protocol

    func play() {
        dispatch_async(serialQueue) { [weak self] in
            self?.queue?.play()
            dispatch_async(dispatch_get_main_queue(), {
                self?.didChangeControlState(state: .Playing)
            })
        }
    }

    func pause() {
        dispatch_async(serialQueue) { [weak self] in
            self?.queue?.pause()
            dispatch_async(dispatch_get_main_queue(), {
                self?.didChangeControlState(state: .Paused)
            })
        }
    }

    func next() {
        self.didChangeControlState(state: .NextTrack)
        dispatch_async(serialQueue) { [weak self] in
            DownloadQueue.sharedInstance.getNextTrack { track in
                guard let strongself = self else { return }
                guard let track = track else { return }
                let trackItem = track.toItem()

                if let queue = strongself.queue {
                    queue.replaceCurrentItemWithPlayerItem(trackItem)
                } else {
                    strongself.initializeQueue(trackItem)
                }
                strongself.addObserverForQueueItem(trackItem)
                strongself.play()
                dispatch_async(dispatch_get_main_queue()) {
                    strongself.nextTrackBeganCallback(track: track)
                }
            }
        }
    }

    func previous() {
        self.didChangeControlState(state: .PreviousTrack)
        dispatch_async(serialQueue) { [weak self] in
            DownloadQueue.sharedInstance.getPreviousTrack { track in
                guard let strongself = self else { return }
                guard let queue = strongself.queue else { return }
                guard let track = track else { return }
                let trackItem = track.toItem()

                queue.replaceCurrentItemWithPlayerItem(trackItem)
                strongself.addObserverForQueueItem(trackItem)
                strongself.play()
                dispatch_async(dispatch_get_main_queue()) {
                    strongself.nextTrackBeganCallback(track: track)
                }
            }
        }
    }

    // MARK: Notifications

    func playerItemDidFinishPlaying(notification: NSNotification) {
        dispatch_async(serialQueue) { [weak self] in
            DownloadQueue.sharedInstance.getNextTrack { track in
                guard let strongself = self else { return }
                guard let queue = strongself.queue else { return }
                guard let track = track else { return }
                let trackItem = track.toItem()

                queue.seekToTime(kCMTimeZero)
                queue.replaceCurrentItemWithPlayerItem(trackItem)
                strongself.addObserverForQueueItem(trackItem)
                strongself.play()
                dispatch_async(dispatch_get_main_queue()) {
                    strongself.nextTrackBeganCallback(track: track)
                }
            }
        }
    }
}
