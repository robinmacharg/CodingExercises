//
//  MarketsViewControllerModel.swift
//  igFxRelated
//
//  Created by Robin Macharg on 18/02/2022.
//

import Foundation

/**
 * A ViewModel for the Markets view controller.  Contains all data required by the VC to display a list of markets.
 * Full MVVM would use model methods for access and have some property observation mechanism.  For now it's just storage.
 */

struct MarketsViewControllerModel {
    var markets: Markets? = nil
    
    /**
     * Trivial setter method
     */
    mutating func updateMarkets(_ markets: Markets) {
        self.markets = markets
    }
}
