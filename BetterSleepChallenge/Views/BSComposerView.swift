//
//  BSComposerView.swift
//  BetterSleepChallenge
//
//  Created by Ace Green on 2023-08-10.
//

import SwiftUI
import AVFAudio

struct BSComposerView: View {
    var viewModel = BSSoundPlayerViewModel.shared
    var callback: ((_ sound: BSComposerViewSoundType, _ wasSelected: Bool) -> Void)?

    var body: some View {
        VStack(spacing: 8) {
            BSSegmentedComposerView()
            BSSegmentedComposerFilterView()
            BSSoundComposerGridView(selectedSounds: viewModel.selectedSounds,
                                    callback: sound)
        }
        .padding(.bottom, 24)
        .padding()
    }

    // MARK: -  BSSoundComposerGridView callback
    func sound(_ sound: BSComposerViewSoundType, _ wasSelected: Bool) {
        callback?(sound, wasSelected)
    }
}

struct BSSegmentedComposerView: View {
    @State private var choice: BSComposerViewType = .sounds

    init() {
        UISegmentedControl.appearance().backgroundColor = .clear
        UISegmentedControl.appearance().setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
    }

    var body: some View {
        VStack {
            Picker("", selection: $choice) {
                ForEach(BSComposerViewType.allCases, id: \.self) {
                    Text($0.description)
                        .font(.title)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

struct BSSegmentedComposerFilterView: View {
    @State private var choice: BSComposerViewFilterType = .all

    var body: some View {
        VStack {
            Picker("", selection: $choice) {
                ForEach(BSComposerViewFilterType.allCases, id: \.self) {
                    Text($0.description)
                        .font(.title2)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

struct BSSoundComposerGridView: View {
    var selectedSounds: [BSSoundModel]
    var callback: ((_ sound: BSComposerViewSoundType, _ wasSelected: Bool) -> Void)?
    @State private var swingAngle: Double = -10

    var body: some View {

        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

        LazyHGrid(rows: columns) {
            ForEach(BSComposerViewSoundType.allCases, id: \.self) { sound in
                Button {
                    callback?(sound, !isSelected(sound: sound))
                } label: {
                    VStack(spacing: -8) {
                        Image(isSelected(sound: sound) ? sound.selectedImageResource : sound.imageResource)
                            .imageScale(.large)
                        Text(sound.description)
                            .font(.caption)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - isSelected()
    func isSelected(sound: BSComposerViewSoundType) -> Bool {
        return selectedSounds.map { $0.sound }.contains(sound)
    }
}

#Preview {
    BSComposerView()
        .preferredColorScheme(.dark)
}
