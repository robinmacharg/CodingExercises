//
//  PLContentDetailItem+Mock.swift
//  PulseliveTests
//
//  Created by Robin Macharg on 29/03/2023.
//

import Foundation
@testable import Pulselive

#if DEBUG
extension PLContentDetailItem {
    static let detail1 = PLContentDetailItem(
        id: 1,
        title: "article1",
        subtitle: "article1 subtitle",
        body: "lorem ipsum foo",
        date: Date.now)
}
#endif
