//
//  Playable.swift
//  LilBits
//
//  Created by Mark Anderson on 2/19/16.
//  Copyright © 2016 markmakingmusic. All rights reserved.
//

import Foundation

// Protocol defining the behavior of the Player

protocol Playable {
    func play()
    func pause()
    func previous()
    func next()
}
