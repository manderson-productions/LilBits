//
//  Produceable.swift
//  LilBits
//
//  Created by Mark Anderson on 2/21/16.
//  Copyright © 2016 markmakingmusic. All rights reserved.
//

import Foundation

// Protocol defining the behavior of a Produceable object

protocol Produceable {
    func getNextTrack(completion: OptionalTrackCallback)
    func getPreviousTrack(completion: OptionalTrackCallback)
}
