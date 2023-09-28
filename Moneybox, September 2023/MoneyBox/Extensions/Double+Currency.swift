//
//  String+Currency.swift
//  MoneyBox
//
//  Created by Robin Macharg on 27/09/2023.
//

import Foundation

extension Double {
    
    /**
     * Convert a Double value into a currency String, e.g 14.3 -> "£14.30"
     */
    func asCurrency(
        symbol: String = "£",
        precision: Int = 2)
    -> String
    {
        return String(format: ("\(symbol)%.\(precision)f"), self)
    }
}
