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

extension Notification.Name {
    static let volumeUp = Notification.Name("VolumeControlVolumeUp")
    static let volumeDown = Notification.Name("VolummeControlVolumeDown")
    static let volumeDoubleTapped = Notification.Name("VolumeControlDoubleTapped")
}

class VolumeControl: NSObject {

    fileprivate enum Constant {
        static let outputVolumeKey = "outputVolume"
        static let volumeKey = "volume"
    }

    fileprivate var initialVolume: Float!
    fileprivate var observing = false
    fileprivate var sessionAlreadyActive: Bool!

    private var volumeChangeTimer: Timer?

    static let shared = VolumeControl()

    private override init() {}

    func enable() {
        guard observing == false else {
            return
        }

        startObserving()
    }

    func disable() {
        guard observing else { return }

        stopObserving()
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


        if let timer = volumeChangeTimer {
            timer.invalidate()
            self.volumeChangeTimer = nil
            NotificationCenter.default.post(name: .volumeDoubleTapped, object: self)
        } else {
            volumeChangeTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
                self.volumeChangeTimer = nil
                if delta > 0 {
                    NotificationCenter.default.post(name: .volumeUp, object: self)
                } else {
                    NotificationCenter.default.post(name: .volumeDown, object: self)
                }
            })
        }
    }

}

private typealias VolumnControlPrivateMethods = VolumeControl
extension VolumnControlPrivateMethods {

    fileprivate func startObserving() {
        let audioSession = AVAudioSession.sharedInstance()

        try? audioSession.setActive(true)
        audioSession.addObserver(self, forKeyPath: Constant.outputVolumeKey, options: [.new], context: nil)

        initialVolume = audioSession.outputVolume
        observing = true
    }

    fileprivate func stopObserving() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
        audioSession.removeObserver(self, forKeyPath: Constant.outputVolumeKey)
    }

    fileprivate func makeVolumeView() -> MPVolumeView {
        return MPVolumeView(frame: CGRect(x: -2000, y: -2000, width: 0, height: 0))
    }
}
