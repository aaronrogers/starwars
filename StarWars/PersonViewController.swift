//
//  PersonViewController.swift
//  StarWars
//
//  Created by Aaron Rogers on 3/15/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit
import Kingfisher

class PersonViewController: UIViewController {

    private var person: Person!

    @IBOutlet private weak var firstNameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    @IBOutlet private weak var birthdateLabel: UILabel!
    @IBOutlet private weak var forceSensitivityLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var affiliationImageView: UIImageView!
    @IBOutlet private weak var infoView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = person.firstName
        infoView.addBlurEffect()

        firstNameLabel.text = person.firstName
        lastNameLabel.text = person.lastName
        forceSensitivityLabel.text = person.forceSensitive ? "Is Force Sensitive" : "Not Force Sensitive"

        let affiliationImage = UIImage(affiliation: person.affiliationEnum())
        affiliationImageView.image = affiliationImage

        let url = URL(string: person.profilePicture)!
        let resouce = ImageResource(downloadURL: url)
        profileImageView.kf.setImage(with: resouce, placeholder: affiliationImage, options: [.transition(.fade(0.2))])

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        birthdateLabel.text = dateFormatter.string(from: person.birthDate)
    }

    func setup(withPerson person: Person) {
        self.person = person
    }
}
