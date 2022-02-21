//
//  MarketValueCell.swift
//  igFxRelated
//
//  Created by Robin Macharg on 18/02/2022.
//

import UIKit

class MarketValueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var moreDetailsButton: UIButton!
    @IBOutlet weak var topMarketImage: UIImageView!
    
    var moreDetailsURL: String?
    
    /**
     * Present more information on a market.
     * Opens the default system browser.
     * TODO: open an in-app browser view.
     */
    @IBAction func showMoreDetails(_ sender: Any) {
        if let urlString = moreDetailsURL, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
        else {
            // TODO: alert, or toast, or try the URL in the background and don't display the button if invalid.
            fatalError()
        }
    }
    
    /**
     * Configures the Top Market indicator (up or down, green or red arrow).  Unsure if this is is a correct interpretation.
     */
    func setIsTopMarket(_ isTopMarket: Bool) {
        if isTopMarket {
            topMarketImage.image = UIImage(systemName: "arrowtriangle.up.fill")
            topMarketImage.tintColor = UIColor.green
        }
        else {
            topMarketImage.image = UIImage(systemName: "arrowtriangle.down.fill")
            topMarketImage.tintColor = UIColor.red
        }
    }
}
