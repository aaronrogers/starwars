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

        // Observe Results Notifications
        notificationToken = people.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            self?.handleNotificationChanges(changes)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PersonTableViewCell

        let person = people[indexPath.row]

        cell.setup(withPerson: person)

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

    private func handleNotificationChanges(_ changes: RealmCollectionChange<Results<Person>>) {
        switch changes {
        case .initial:
            // Results are now populated and can be accessed without blocking the UI
            tableView.reloadData()
            break
        case .update(_, let deletions, let insertions, let modifications):
            // Query results have changed, so apply them to the UITableView
            tableView.beginUpdates()
            tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                 with: .automatic)
            tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                 with: .automatic)
            tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                 with: .automatic)
            tableView.endUpdates()
            break
        case .error(let error):
            // An error occurred while opening the Realm file on the background worker thread
            fatalError("\(error)")
            break
        }
    }

}
