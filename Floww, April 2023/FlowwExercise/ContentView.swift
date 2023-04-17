//
//  ContentView.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 12/04/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            MarketListScreen()
                .edgesIgnoringSafeArea(.bottom)
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
