//
//  LoadingOverlay.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 13/04/2023.
//

import SwiftUI

struct LoadingOverlay: View {

    var message: String

    var body: some View {
        VStack(spacing: 8) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
            Text(message)
        }
        .foregroundColor(.black)
        .padding()
        .background {
            Color("lightGray")
        }
        .cornerRadius(10)
    }
}

#if DEBUG
struct LoadingOverlay_Previews: PreviewProvider {
    static var previews: some View {
        LoadingOverlay(message: "Loading Markets")
    }
}
#endif
