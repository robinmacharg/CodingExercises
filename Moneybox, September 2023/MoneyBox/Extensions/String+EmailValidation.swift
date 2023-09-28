//
//  String+EmailValidation.swift
//  MoneyBox
//
//  Created by Robin Macharg on 27/09/2023.
//

import Foundation

// See https://stackoverflow.com/a/41782027/2431627
// Note the point in a subsequent answer about using a validation package that is RFC5322-compliant.
// I've stuck with this as "good enough", and not wanted to bring in yet another package.

let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)

extension String {
    func isEmail() -> Bool {
        return __emailPredicate.evaluate(with: self)
    }
}
