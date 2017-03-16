//
//  PeopleTableViewController.swift
//  StarWars
//
//  Created by Aaron Rogers on 3/15/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit
import RealmSwift

class PeopleTableViewController: UITableViewController {

    var notificationToken: NotificationToken? = nil
    var people: Results<Person>!

    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        people = realm.objects(Person.self)
        title = "People"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let person = people[indexPath.row]

        cell.textLabel?.text = "\(person.firstName) \(person.lastName)"

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showPerson",
            let vc = segue.destination as? PersonViewController,
            let selectedPath = tableView.indexPathForSelectedRow
            else { return }

        let person = people[selectedPath.row]
        vc.setup(withPerson: person)
    }

}
