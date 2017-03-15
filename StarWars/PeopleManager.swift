//
//  PeopleManager.swift
//  StarWars
//
//  Created by Aaron Rogers on 3/15/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class PeopleManager {
    private typealias JSONObject = [String: Any]

    private enum Constant {
        static let apiUrl = "https://edge.ldscdn.org/mobile/interview/directory"
    }

    private enum JSONKey {
        static let individuals = "individuals"
    }

    static let shared = PeopleManager()

    private init() {}

    func startup() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let url = URL(string: Constant.apiUrl)!
        let task = session.dataTask(with: url) { (data, response, error) in

            switch (data, error) {
            case let (_, .some(error)):
                print("There was an error contacting the server.\n", error.localizedDescription)
            case let (.some(data), _):
                self.processData(data)
            default:
                print("There was a problem getting data from the server.  There was neither an error or data.\nResponse\n", response as Any)
            }
        }

        task.resume()
    }

    private func processData(_ data: Data) {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONObject else {
                print("Could not get dictionary from JSON")
                return
            }

            guard let individuals = json[JSONKey.individuals] as? [JSONObject] else {
                print("Could not get individuals from JSON")
                return
            }

            for individual in individuals {
                print(individual)
            }

        } catch {
            print("There was a problem parsing the JSON", error.localizedDescription)
        }
    }
}
