import Foundation
import SwiftUI
import AVFoundation

struct EpisodeModeView: View {
    @State private var player: AVAudioPlayer?
    @State private var isPlaying = false
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).edgesIgnoringSafeArea(.all) // 背景色
            
            VStack(spacing: 80) { // ボタン間の距離を広げる
                Text("Episode Mode") // 画面上部のテキスト
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // 再生/一時停止ボタン
                Button(action: {
                    if self.isPlaying {
                        self.player?.pause()
                    } else {
                        if self.player?.isPlaying == false {
                            self.player?.currentTime = 0
                        }
                        let sound = Bundle.main.path(forResource: "tomeigirls", ofType: "mp3")
                        self.player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                        self.player?.play()
                    }
                    self.isPlaying.toggle()
                }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .foregroundColor(isPlaying ? .red : .white) // 色を変更
                }

                // ホームボタン
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
        .navigationBarHidden(true) // ナビゲーションバーを非表示に
        .onDisappear { // 画面が消えるときに音楽を停止
            self.player?.stop()
            self.isPlaying = false
        }
    }
}
