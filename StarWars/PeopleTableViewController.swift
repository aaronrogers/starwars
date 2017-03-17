//
//  PeopleTableViewController.swift
//  StarWars
//
//  Created by Aaron Rogers on 3/15/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class PeopleTableViewController: UITableViewController {

    private enum Constant {
        static let showPerson = "showPerson"
        static let doubleClickTolerance: TimeInterval = 0.3
    }

    var notificationToken: NotificationToken? = nil
    var people: Results<Person>!
    var volumeControl: VolumeControl!
    var selectedIndex: Int?
    var volumeTappedTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        people = realm.objects(Person.self)
        title = "People"

        // Observe Results Notifications
        notificationToken = people.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            self?.handleNotificationChanges(changes)
        }

        volumeControl = VolumeControl()
        volumeControl.watchForChange(volumeUp: {
            self.volumeChanged(up: true)
        }, volumeDown: {
            self.volumeChanged(up: false)
        })
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
        guard segue.identifier == Constant.showPerson,
            let vc = segue.destination as? PersonViewController
            else { return }

        let selectedPath = tableView.indexPathForSelectedRow!
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

    private func volumeChanged(up: Bool) {
        if let timer = volumeTappedTimer {
            timer.invalidate()
            self.volumeTappedTimer = nil
            selectCurrent()
            return
        }

        volumeTappedTimer = Timer.scheduledTimer(withTimeInterval: Constant.doubleClickTolerance, repeats: false, block: { timer in
            self.volumeTappedTimer = nil
            if up {
                self.changeSelectedIndex(delta: -1)
            } else {
                self.changeSelectedIndex(delta: 1)
            }
        })
    }

    private func selectCurrent() {
        if tableView.indexPathForSelectedRow == nil {
            tableView.selectRow(at: IndexPath(row: selectedIndex ?? 0, section: 0), animated: true, scrollPosition: .middle)
        }
        performSegue(withIdentifier: Constant.showPerson, sender: tableView)
    }

    func changeSelectedIndex(delta: Int) {
        // don't want to react while it's not the main view
        guard isViewLoaded && view.window != nil else { return }

        var newIndex: Int

        if let selectedIndex = selectedIndex {
            newIndex = selectedIndex + delta
        } else {
            print(tableView.contentOffset.y)
            if tableView.contentOffset.y <= 0 {
                // already at top, go to next
                print("already at top")
                newIndex = 1
            } else {
                newIndex = 0
            }
        }

        if newIndex > people.count - 1 {
            newIndex = 0
        } else if newIndex < 0 {
            newIndex = people.count - 1
        }

        self.selectedIndex = newIndex
        tableView.selectRow(at: IndexPath(row: newIndex, section: 0), animated: true, scrollPosition: .middle)
    }

}
