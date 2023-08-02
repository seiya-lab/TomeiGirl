//
//  ContentView.swift
//  TomeiGirl
//
//  Created by tanaka on 2023/08/02.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.8).edgesIgnoringSafeArea(.all) // 背景色
                
                VStack(spacing: 40) { // ボタン同士の間隔を広げる
                    Spacer().frame(height: 20)
                    // タイトル画像（画面上部に配置、さらに小さく、余白を追加）
                    Image("TomeiGirl")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.1) // 両端に10%の余白

                    // Episode Modeボタン
                    NavigationLink(destination: EpisodeModeView()) {
                        buttonContent(imageName: "EpisodeMode", text: "Episode Mode")
                    }

                    // Syutoku Modeボタン
                    NavigationLink(destination: SyutokuModeView()) {
                        buttonContent(imageName: "SyutokuMode", text: "Syutoku Mode")
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true) // ナビゲーションバーを非表示に
    }
    
    // ボタンのコンテンツを生成する共通関数
    private func buttonContent(imageName: String, text: String) -> some View {
        HStack {
            Image(imageName) // 画像サイズを調整
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100) // 画像サイズを大きく
            Text(text)
                .foregroundColor(.white) // テキスト色を白に
                .font(.headline) // テキストを太く、大きく
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.8) // 画面の両端に10%の余白
        .background(RoundedRectangle(cornerRadius: 10) // 枠の中を背景より薄い灰色で埋める
                        .fill(Color.gray.opacity(0.7)))
    }
}
