//
//  PersonViewController.swift
//  StarWars
//
//  Created by Aaron Rogers on 3/15/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {

    private var person: Person!

    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = "\(person.firstName) \(person.lastName)"
        title = "\(person.firstName) \(person.lastName)"
    }

    func setup(withPerson person: Person) {
        self.person = person
    }
}
