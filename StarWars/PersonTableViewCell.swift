//
//  PersonTableViewCell.swift
//  StarWars
//
//  Created by Aaron Rogers on 3/15/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit
import Kingfisher

class PersonTableViewCell: UITableViewCell {

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var firstNameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    @IBOutlet private weak var backgroundNameView: UIView!

    private var person: Person!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        if UIAccessibilityIsReduceTransparencyEnabled() == false {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)

            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = backgroundNameView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundNameView.insertSubview(blurEffectView, at: 0)

            vibrancyView.frame = blurEffectView.bounds
            blurEffectView.addSubview(vibrancyView)

            backgroundNameView.backgroundColor = .clear
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(withPerson person: Person) {
        self.person = person

        let image: UIImage
        switch person.affiliationEnum() {
        case .firstOrder:
            image = UIImage(named: "placeholder_jedi")!
        case .jedi:
            image = UIImage(named: "placeholder_firstorder")!
        case .resistance:
            image = UIImage(named: "placeholder_resistance")!
        case .sith:
            image = UIImage(named: "placeholder_sith")!
        }

        let url = URL(string: person.profilePicture)!
        let resouce = ImageResource(downloadURL: url)
        profileImageView.kf.setImage(with: resouce, placeholder: image)

        firstNameLabel.text = person.firstName
        lastNameLabel.text = person.lastName
        firstNameLabel.textColor = .white
        lastNameLabel.textColor = .white
    }

}
