//
//  VolumeControl.swift
//  StarWars
//
//  Created by Aaron Rogers on 3/17/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer


typealias VolumeBlock = () -> ()
class VolumeControl: NSObject {

    fileprivate enum Constant {
        static let outputVolumeKey = "outputVolume"
        static let volumeKey = "volume"
    }

    fileprivate var volumeUpCallback: VolumeBlock?
    fileprivate var volumeDownCallback: VolumeBlock?
    fileprivate var initialVolume: Float!
    fileprivate var observing = false
    fileprivate var volumeView: MPVolumeView?

    func watchForChange(volumeUp: @escaping VolumeBlock, volumeDown: @escaping VolumeBlock) {
        self.volumeUpCallback = volumeUp
        self.volumeDownCallback = volumeDown
        enable()
    }

    deinit {
        disable()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        guard keyPath == Constant.outputVolumeKey,
              let theChange = change,
              let newVolume = theChange[.newKey] as? Float else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
                return
        }

        let delta = newVolume - initialVolume
//        print("initial \(initialVolume), new \(newVolume), delta \(delta)")

        // see if there's a change
        guard delta != 0 else { return }

        // reset value
        MPMusicPlayerController.applicationMusicPlayer().setValue(NSNumber(value: initialVolume), forKey: Constant.volumeKey)

        if delta > 0 {
            volumeUpCallback?()
        } else {
            volumeDownCallback?()
        }
    }

}

private typealias VolumnControlPrivateMethods = VolumeControl
extension VolumnControlPrivateMethods {
    fileprivate func enable() {
        guard observing == false else {
            return
        }

        disableVolumeView()
        startObserving()
    }

    fileprivate func disable() {
        guard observing else { return }

        stopObserving()
        enableVolumeView()
    }

    private func startObserving() {
        let audioSession = AVAudioSession.sharedInstance()

        try? audioSession.setActive(true)
        audioSession.addObserver(self, forKeyPath: Constant.outputVolumeKey, options: [.new], context: nil)

        initialVolume = audioSession.outputVolume
        observing = true
    }

    private func stopObserving() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
        audioSession.removeObserver(self, forKeyPath: Constant.outputVolumeKey)
    }

    private func disableVolumeView() {
        if volumeView == nil {
            volumeView = makeVolumeView()
        }

        UIApplication.shared.windows.first?.addSubview(volumeView!)
    }

    private func enableVolumeView() {
        volumeView?.removeFromSuperview()
        volumeView = nil
    }

    fileprivate func makeVolumeView() -> MPVolumeView {
        return MPVolumeView(frame: CGRect(x: -2000, y: -2000, width: 0, height: 0))
    }
}
