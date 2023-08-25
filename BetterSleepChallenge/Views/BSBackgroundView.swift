//
//  BSBackgroundView.swift
//  BetterSleepChallenge
//
//  Created by Ace Green on 2023-08-09.
//

import SwiftUI

struct BSBackgroundView<Content>: View where Content : View {
    let content: () -> Content

    @inlinable init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        BSBackgroundBuilder()
            .overlay(self.content())
    }
}

struct BSBackgroundBuilder: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(.background)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Image(.bottomMoon)
                .resizable()
                .scaledToFit()
                .offset(y: -120)
            Image(.bottomMountains)
                .resizable()
                .scaledToFit()
                .offset(y: -60)
            Image(.bottomGrass)
                .resizable()
                .scaledToFit()

        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    BSBackgroundView {
        Text("Home")
            .font(.largeTitle)
            .foregroundStyle(.white)
    }
    .preferredColorScheme(.dark)
}
