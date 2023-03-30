//
//  ContentView.swift
//  Pulselive
//
//  Created by Robin Macharg on 28/03/2023.
//

import SwiftUI

/**
 * The top-level View
 */
struct ContentView: View {
    var body: some View {
        NavigationStack {
            ContentListScreen()
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
