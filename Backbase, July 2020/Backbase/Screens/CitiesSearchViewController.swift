//
//  CitiesSearchViewController.swift
//  Backbase
//
//  Created by Robin Macharg on 09/07/2020.
//  Copyright © 2020 Robin Macharg. All rights reserved.
//

import UIKit

class CitiesSearchViewController: UITableViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    
    var cities: [City] = []
    var selectedCity: City? = nil
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // https://stackoverflow.com/a/25916838/2431627
        self.tableView.rowHeight = 85;

        // Register for notifications, before doing anything else
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification(_:)),
            name: .startLoadingData,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification(_:)),
            name: .endLoadingData,
            object: nil)
        
        // Kick off loading the city data on app start-up.  Backgrounded
        API.shared.load()
    }

    // MARK: - Notification handler
    
    @objc func handleNotification(_ notification: Notification)
    {
        switch notification.name {
        case .startLoadingData:
            // TODO: spinner
            break
        case .endLoadingData:
            cities = DataStore.shared.search()
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        default:
            break
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        (segue.destination as? MapViewController)?.city = selectedCity
    }
}


// MARK: - <UITableViewDataSource>

extension CitiesSearchViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as? CityCell {
            let city = cities[indexPath.row]
            cell.cityName.text = "\(city.name), \(city.country)"
            cell.location.text = "(lat: \(city.coord.lat), lon: \(city.coord.lon))"

            cell.accessibilityIdentifier = city.name // Enable testability
            return cell
        }
        fatalError("Can't dequeue cell")
    }
}

// MARK: - <UITableViewDelegate>

extension CitiesSearchViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCity = cities[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "CitySearchToMap", sender: self)
    }
}


// MARK: - <UISearchBarDelegate>

extension CitiesSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cities = DataStore.shared.search(text: searchText.lowercased())
        tableView.reloadData()
    }
}
