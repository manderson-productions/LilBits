//
//  PlayerViewController.swift
//  LilBits
//
//  Created by Mark Anderson on 2/19/16.
//  Copyright © 2016 markmakingmusic. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController, PlayerObservable {

    // MARK: Properties/ IBOutlets

    private var player: Player!

    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playPauseButton: PlayPauseButton!
    @IBOutlet weak var nextButton: UIButton!

    // MARK: ViewLifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.player = Player(
            controlStateDidChange: didChangeControlState,
            nextTrackBeganCallback: didBeginPlayback)
    }

    // MARK: IBActions

    @IBAction func previousButtonPressed(sender: UIButton) {
        player.previous()
    }

    @IBAction func playPauseButtonPressed(sender: PlayPauseButton) {
        if sender.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }

    @IBAction func nextButtonPressed(sender: UIButton) {
        player.next()
    }

    // MARK: Private Methods

    private func setTrackInfo(track: Track) {
        artistNameLabel.text = track.artistName
        trackNameLabel.text = track.name

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            guard let url = NSURL(string: track.coverImage) else { return }
            guard let imageData = NSData(contentsOfURL: url) else { return }
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                self?.coverImageView.image = UIImage(data: imageData, scale: UIScreen.mainScreen().scale)
            })
        }
    }

    private func setControlState(state: ControlState) {
        switch state {
        case .Playing:
            playPauseButton.enabled = true
            nextButton.enabled = true
            previousButton.enabled = true
            playPauseButton.isPlaying = true
        case .Paused:
            playPauseButton.enabled = true
            nextButton.enabled = true
            previousButton.enabled = true
            playPauseButton.isPlaying = false
        case .NextTrack:
            playPauseButton.enabled = false
            nextButton.enabled = false
            previousButton.enabled = false
        case .PreviousTrack:
            playPauseButton.enabled = false
            nextButton.enabled = false
            previousButton.enabled = false
        }
    }

    // MARK: PlayerObservable

    func didChangeControlState(state: ControlState) {
        setControlState(state)
    }

    func didBeginPlayback(track: Track) {
        setTrackInfo(track)
    }
}
