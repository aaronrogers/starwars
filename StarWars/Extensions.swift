//
//  Extensions.swift
//  StarWars
//
//  Created by Aaron Rogers on 3/16/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init(affiliation: Affiliation) {
        let name: String
        switch affiliation {
        case .resistance: name = "icon_resistance"
        case .jedi: name = "icon_jedi"
        case .firstOrder: name = "icon_firstorder"
        case .sith: name = "icon_sith"
        }

        self.init(named: name)!
    }
}

extension UIView {
    func addBlurEffect() {
        if UIAccessibilityIsReduceTransparencyEnabled() == false {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)

            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.insertSubview(blurEffectView, at: 0)

            vibrancyView.frame = blurEffectView.bounds
            blurEffectView.addSubview(vibrancyView)

            self.backgroundColor = .clear
        }
    }
}
