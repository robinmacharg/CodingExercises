//
//  MarketsViewController.swift
//  igFxRelated
//
//  Created by Robin Macharg on 18/02/2022.
//

import UIKit

class MarketsViewController: UIViewController {
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var marketSelectionSegmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    
    var model = MarketsViewControllerModel()
    var refreshControl: UIRefreshControl!
    
    private var loadingIndicator: UIAlertController?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        // Ensure that the refresh control is under the table
        refreshControl.layer.zPosition = -1
        
        loadData()
    }
    
    // MARK: - Actions
    
    /**
     * Load the data for this VC asynchronously
     */
    func loadData() {
        
        loadingIndicator = self.showBusyIndicator(message: "Loading Markets...")
        
        API.shared.getMarkets { [self] result in
            hideBusyIndicator(loader: loadingIndicator)
            
            switch result {
            case .failure(let error):
                print("failure: \(error.localizedDescription)")
            case .success(let markets):
                model.updateMarkets(markets)
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    if refreshControl?.isRefreshing ?? false {
                        refreshControl?.endRefreshing()
                    }
                    tableView.reloadData()
                }
            }
        }
    }

    /**
     * Scroll the table to the market selected by the top segmented control
     */
    @IBAction func marketChanged(_ sender: Any) {
        let marketIndex = marketSelectionSegmentedControl.selectedSegmentIndex
        let indexPath = IndexPath(row: 0, section: marketIndex)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    /**
     * Called by the table pull-to-refresh
     */
    @objc private func refresh(_ sender: AnyObject) {
        loadData()
    }
}

// MARK: - <UITableViewDelegate>

extension MarketsViewController: UITableViewDelegate {
    // Unused - would be removed in production code; left to show awareness.
}

// MARK: - <UITableViewDataSource>

extension MarketsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.markets == nil ? 0 : 3 // hardcoded
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let markets = model.markets else {
            return 0
        }
                
        switch MarketSection(rawValue: section) {
        case .currencies:
            return markets.currencies.count
        case .commodities:
            return markets.commodities.count
        case .indices:
            return markets.indices.count
        case .none:
            fatalError("Unexpected market section")
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        guard let markets = model.markets,
              let cell = tableView.dequeueReusableCell(
                withIdentifier: "MarketValueCell",
                for: indexPath) as? MarketValueTableViewCell
        else {
            // TODO: "No data, please refresh"
            return UITableViewCell()
        }

        let marketValues: [Market]
        
        switch MarketSection(rawValue: indexPath.section) {
        case .currencies:
            marketValues = markets.currencies
        case .commodities:
            marketValues = markets.commodities
        case .indices:
            marketValues = markets.indices
        case .none:
            fatalError("Unexpected market section")
        }
    
        let marketValue = marketValues[indexPath.row]
        
        cell.displayName?.text = marketValue.displayName
        cell.moreDetailsURL = marketValue.rateDetailURL
        cell.setIsTopMarket(marketValue.topMarket)
        
        return cell
    }
    
    /**
     * Generate an appropriate section header with item count
     *
     * Note: We could have used a custom header with the viewForHeaderInSection method.
     * This is simpler, and within the task scope.
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        guard var text = MarketSection(rawValue: section)?.displayValue else {
            return "Unknown Market Values"
        }
        
        var count: Int?
        
        if let markets = model.markets {
            switch (MarketSection(rawValue: section)) {
            case .commodities:
                count = markets.commodities.count
            case .currencies:
                count = markets.currencies.count
            case .indices:
                count = markets.indices.count
            case .none:
                break
            }
        }
        
        if let count = count {
            text += " (\(count) items)"
        }
        
       return text
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
}
