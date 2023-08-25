//
//  BSTabView.swift
//  BetterSleepChallenge
//
//  Created by Ace Green on 2023-08-10.
//

import SwiftUI
import ActivityKit

struct BSTabView: View {
    @State var viewModel = BSSoundPlayerViewModel.shared
    @State private var tabSelectionIndex = 1
    @State private var showPlayer: Bool = false
    @State private var showAlert: Bool = false
    @State private var autoplay: Bool = false
    @State private var liveActivity: Activity<BetterSleepChallengeWidgetAttributes>?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabView(selection: $tabSelectionIndex) {
                    Group {
                        BSBackgroundView {
                            Text("Home")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                        }
                        .tabItem {
                            Label("Home", systemImage: "moon.stars")
                        }
                        .tag(0)
                        BSBackgroundView {
                            BSComposerView(callback: sound)
                        }
                        .tabItem {
                            Label("Composer", systemImage: "music.quarternote.3")
                        }
                        .tag(1)
                        BSBackgroundView {
                            Text("Sleep")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                        }
                        .tabItem {
                            Label("Sleep", systemImage: "sleep")
                        }
                        .tag(2)
                        BSBackgroundView {
                            Text("Profile")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                        }
                        .tabItem {
                            Label("Profile", systemImage: "person.2.fill")
                                .symbolRenderingMode(.multicolor)
                        }
                        .tag(3)
                    }
                    .toolbarBackground(.black, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarColorScheme(.dark, for: .tabBar)
                }
                if showPlayer {
                    BSSoundPlayerView(autoplay: $autoplay)
                        .offset(y: -60)
                }
            }
        }
        // MARK: - Fetch userdefaults and store sounds globally
        .onAppear {
            // set selected sounds from userdefaults
            BSConstants.shared.selectedSoundNames.forEach { selectedSoundFileName in
                guard let sound = BSComposerViewSoundType(rawValue: selectedSoundFileName) else { return }
                let soundModel = BSSoundModel(sound: sound)
                viewModel.add(soundModel: soundModel)
                showPlayer = true
            }

            // launch live activity
            startLiveActivity()
        }
        // MARK: - logic to update player, done initially & on every selectedSounds change
        .onChange(of: viewModel.selectedSounds, initial: true) { oldValue, newValue in
            if newValue.isEmpty {
                showPlayer = false
            } else {
                showPlayer = true
            }

            viewModel.update(oldValue: oldValue,
                             newValue: newValue,
                             autoplay: autoplay)
        }
        // MARK: - logic for playing/pausing player on isPlaying change
        .onChange(of: viewModel.isPlaying) {
            if viewModel.isPlaying == true {
                viewModel.play()
                Task {
                    await updateLiveActivity()
                }
            } else {
                viewModel.pause()
                Task {
                    await stopLiveActivity()
                }
            }
        }
        // MARK: - show alert when selectedSound > 3
        .alert("Sound limit reached", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }

    // MARK: -  BSComposerView callback
    func sound(_ sound: BSComposerViewSoundType, _ wasSelected: Bool) {
        let soundModel = BSSoundModel(sound: sound)
        switch wasSelected {
        case true:
            if viewModel.selectedSounds.count < BSConstants.soundslimit {
                viewModel.add(soundModel: soundModel)
            } else if viewModel.selectedSounds.count >= BSConstants.soundslimit {
                showAlert.toggle()
            }
            autoplay = true
        case false:
            viewModel.remove(soundModel: soundModel)
        }
    }

    // MARK: - Live activity methods
    func startLiveActivity() {
        let recordingAttributes = BetterSleepChallengeWidgetAttributes()
        let state =  BetterSleepChallengeWidgetAttributes.ContentState.upcoming
        let content = ActivityContent(state: state, staleDate: nil, relevanceScore: 1.0)

        do {
            liveActivity = try Activity.request(
                attributes: recordingAttributes,
                content: content,
                pushType: nil
            )
        } catch {
            print(error.localizedDescription)
        }
    }

    func updateLiveActivity() async {
        let state = BetterSleepChallengeWidgetAttributes.ContentState.started
        await liveActivity?.update(
            ActivityContent<BetterSleepChallengeWidgetAttributes.ContentState>(
                state: state,
                staleDate: nil
            ), alertConfiguration: AlertConfiguration(title: "TEST", body: "TEST", sound: .default)
        )
    }

    func stopLiveActivity() async {
        let state = BetterSleepChallengeWidgetAttributes.ContentState.ended
        await liveActivity?.end(
            ActivityContent<Activity<BetterSleepChallengeWidgetAttributes>.ContentState>(
                state: state,
                staleDate: nil
            ), dismissalPolicy: .default)
    }
}

struct BSSoundPlayerView: View {
    @State var viewModel = BSSoundPlayerViewModel.shared
    @State private var title: String = "Current Mix"
    @Binding var autoplay: Bool
    @State private var showPlayerDetailSheet = false

    var body: some View {
        HStack(alignment: .center) {
            Button {
                showPlayerDetailSheet.toggle()
            } label: {
                Image(systemName: "chevron.up")
                    .imageScale(.large)
            }
            .sheet(isPresented: $showPlayerDetailSheet) {
                VStack(spacing: 8) {
                    Text("Sounds")
                        .font(.title2)
                        .padding()
                        .hSpacing(.leading)
                    Group {
                        ForEach($viewModel.selectedSounds, id: \.self) { $soundModel in
                            BSSoundListRow(soundModel: soundModel, volume: $soundModel.volume)
                        }
                    }
                    .padding(.trailing)
                    Button {
                        viewModel.clear()
                    } label: {
                        Text("Clear all")
                            .frame(minWidth: 180)
                            .font(.callout)
                            .fontWeight(.medium)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue.opacity(0.3))
                    .cornerRadius(24)
                    .hSpacing(.center)
                }
                .vSpacing(.topLeading)
                .presentationDetents([.medium])
                .preferredColorScheme(.dark)
                .background(.ultraThinMaterial)
            }
            Spacer()
            VStack {
                Text(title)
                    .font(.callout)
                    .foregroundStyle(.white)
                    .bold()
                Text("\(viewModel.selectedSounds.count) items")
                    .font(.body)
                    .foregroundStyle(.white).opacity(0.5)
            }
            Spacer()
            Button {
                DispatchQueue.main.async {
                    viewModel.isPlaying.toggle()
                }
                autoplay = true
            } label: {
                Image(systemName: viewModel.isPlaying ? "pause.circle" : "play.circle")
                    .imageScale(.large)
            }
        }
        .frame(maxWidth: 320)
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
    }
}

struct BSSoundListRow: View {

    var soundModel: BSSoundModel
    @Binding var volume: Float

    var body: some View {
        HStack {
            Image(soundModel.sound.imageResource)
                .imageScale(.large)
            VStack(alignment: .leading, spacing: 0) {
                Text(soundModel.sound.description)
                    .font(.callout)
                Slider(value: $volume, in: 0...1)
                    .tint(.blue.opacity(0.3))
            }
        }
    }
}

#Preview {
    BSTabView()
        .preferredColorScheme(.dark)
}


