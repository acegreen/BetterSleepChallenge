//
//  View+Extensions.swift
//  BetterSleepChallenge
//
//  Created by Ace Green on 2023-08-10.
//

import SwiftUI

/*
 Use like:
 struct SomeView: some View {
     var body: View {
         Text("SomeView")
             .hSpacing(.leading)
             .vSpacing(.center)
     }
 }
*/
extension View {

    // MARK: - hSpacing
    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }

    // MARK: - vSpacing
    @ViewBuilder
    func vSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
}

