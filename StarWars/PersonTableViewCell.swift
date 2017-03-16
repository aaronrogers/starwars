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

        backgroundNameView.addBlurEffect()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(withPerson person: Person) {
        self.person = person

        let image = UIImage(affiliation: person.affiliationEnum())
        let url = URL(string: person.profilePicture)!
        let resouce = ImageResource(downloadURL: url)
        profileImageView.kf.setImage(with: resouce, placeholder: image, options: [.transition(.fade(0.2))])

        firstNameLabel.text = person.firstName
        lastNameLabel.text = person.lastName
        firstNameLabel.textColor = .white
        lastNameLabel.textColor = .white
    }
}
