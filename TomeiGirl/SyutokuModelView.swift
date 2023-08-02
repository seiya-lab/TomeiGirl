import SwiftUI
import AVFoundation

struct SyutokuModeView: View {
    @State private var isEditing: Bool = false
    @State private var player: AVAudioPlayer?
    @State private var remainingTime: Double = 0
    @State private var internalRemainingTime: Double = 0 // 内部の残り時間
    @State private var isTimerRunning = false
    @State private var isMusicPlaying = false
    @State private var buttonColor: Color = .white
    @State private var seconds: String = ""
    @State private var buttonIcon: String = "watch"
    @State private var isInternalTimerRunning = false

    var body: some View {
        ZStack {
            // タップジェスチャーでキーボードを閉じる
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }

            Color(isInternalTimerRunning ? .blue : .gray).opacity(0.8).edgesIgnoringSafeArea(.all) // 内部タイマーが動作中のみ青


            VStack(spacing: 20) {
                Text("Syutoku Mode")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)

                HStack {
                    TextField("Seconds", text: $seconds) { isEditing in
                        self.isEditing = isEditing
                    }
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Go") {
                        hideKeyboard()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
                .onChange(of: seconds) { newValue in
                    if let inputSeconds = Double(newValue), inputSeconds >= 0 && inputSeconds <= 120 {
                        remainingTime = inputSeconds
                        internalRemainingTime = inputSeconds
                    }
                }

                Text(String(format: "%.2f", max(0, remainingTime)))
                    .font(.system(size: 80))
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Button(action: handlePlayStopButton) {
                    Circle()
                        .fill(buttonColor)
                        .frame(width: 200, height: 200)
                        .overlay(
                            Image(buttonIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        )
                }
                .disabled(seconds.isEmpty || isMusicPlaying)

                Button(action: {
                    player?.stop()
                    isMusicPlaying = false
                }) {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "stop.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        )
                }
                .disabled(!isMusicPlaying)

                NavigationLink(destination: ContentView()) {
                    HStack {
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                        Text("Home")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.8)))
                }
            }
        }
        .navigationBarHidden(true)
        .onDisappear {
            self.player?.stop()
            self.isTimerRunning = false
        }
    }

    private func handlePlayStopButton() {
        if isTimerRunning {
            isTimerRunning = false
            updateButtonAppearance()
        } else {
            startTimers()
        }
    }

    private func startTimers() {
        if let inputSeconds = Double(seconds), inputSeconds >= 0 && inputSeconds <= 120 {
            remainingTime = inputSeconds
            internalRemainingTime = inputSeconds
            isInternalTimerRunning = true // 内部タイマーの開始

            // 表示用タイマー
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                if remainingTime > 0 && isTimerRunning {
                    remainingTime -= 0.01
                } else {
                    timer.invalidate()
                }
            }

            // 内部タイマー
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                if internalRemainingTime > 0 {
                    internalRemainingTime -= 0.01
                } else {
                    timer.invalidate()
                    isInternalTimerRunning = false // 内部タイマーの終了
                    playMusic()
                }
            }

            isTimerRunning = true
            buttonIcon = "stop.fill"
            buttonColor = .yellow
        }
    }

    private func playMusic() {
        let sound = Bundle.main.path(forResource: "tomeigirls", ofType: "mp3")
        player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        player?.play()
        isMusicPlaying = true
        if isTimerRunning{
            buttonIcon = "tort"
            buttonColor = .red
        }
    }

    private func updateButtonAppearance() {
        buttonIcon = remainingTime <= 3 ? "crown" : "rooster"
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
