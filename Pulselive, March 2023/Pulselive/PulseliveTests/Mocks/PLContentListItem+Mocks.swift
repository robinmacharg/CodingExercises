//
//  PLContentListItem+Mocks.swift
//  PulseliveTests
//
//  Created by Robin Macharg on 29/03/2023.
//

import Foundation
@testable import Pulselive

#if DEBUG
public extension PLContentListItem {
    static let item1 = PLContentListItem(id: 1, title: "article1", subtitle: "article1 subtitle", date: Date.now)
    static let item2 = PLContentListItem(id: 2, title: "article2", subtitle: "article2 subtitle", date: Date.now)
    static let item3 = PLContentListItem(id: 3, title: "article3", subtitle: "article3 subtitle", date: Date.now)
    static let item4 = PLContentListItem(id: 4, title: "article4", subtitle: "article4 subtitle", date: Date.now)
}
#endif
