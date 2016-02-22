//
//  PlayerObservable.swift
//  LilBits
//
//  Created by Mark Anderson on 2/19/16.
//  Copyright © 2016 markmakingmusic. All rights reserved.
//

import Foundation

// Protocol defining the behavior of an observer that observes Player state changes

protocol PlayerObservable {
    func didChangeControlState(state: ControlState)
    func didBeginPlayback(track: Track)
}
