//
//  PlayPauseButton.swift
//  LilBits
//
//  Created by Mark Anderson on 2/19/16.
//  Copyright © 2016 markmakingmusic. All rights reserved.
//

import UIKit

// A UIButton subclass that acts on changes made to its isPlaying property

class PlayPauseButton: UIButton {
    var isPlaying: Bool = false {
        didSet {
            if isPlaying == true {
                self.backgroundColor = UIColor.greenColor()
                self.setTitle("Pause", forState: .Normal)
            } else {
                self.backgroundColor = UIColor.redColor()
                self.setTitle("Play", forState: .Normal)
            }
        }
    }
}
