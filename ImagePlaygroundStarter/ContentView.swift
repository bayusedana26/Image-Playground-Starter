//
//  ContentView.swift
//  ImagePlaygroundStarter
//
//  Created by Sean Allen on 1/29/25.
//  Modified by: Bayu Sedana
//

import SwiftUI
import PhotosUI
import ImagePlayground

struct ContentView: View {
    // Attributes
    @Environment(\.supportsImagePlayground) var supportsImagePlayground
    @State private var prompt: String = ""
    @State private var isShowingImagePlayground = false

    @State private var avatarImage: Image?
    @State private var photosPickerItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 32) {
            HStack(spacing: 20) {
                PhotosPicker(selection: $photosPickerItem, matching: .not(.screenshots)) {
                    (avatarImage ?? Image(systemName: "person.circle.fill"))
                        .resizable()
                        .foregroundStyle(.mint)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(.circle)
                }

                VStack(alignment: .leading) {
                    Text("Bayu Sedana")
                        .font(.title.bold())

                    Text("iOS Developer").bold()
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            
            if supportsImagePlayground {
                TextField("Enter avatar description", text: $prompt)
                    .font(.title3.bold())
                    .padding()
                    .background(.quaternary, in: .rect(cornerRadius: 16, style: .continuous))
                
                Button("Generate Image", systemImage: "sparkles") {
                    isShowingImagePlayground = true
                    }
                .padding()
                .foregroundStyle(.mint)
                .fontWeight(.bold)
                .background(RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(.mint, lineWidth: 3)
                )
            }
            
            Spacer()
        }
        .padding(30)
        .onChange(of: photosPickerItem) { _, _ in
            Task {
                if let photosPickerItem, let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) { avatarImage = Image(uiImage: image) }
                }
            }
        }
        .imagePlaygroundSheet(isPresented: $isShowingImagePlayground,
                              concept: prompt,
                              sourceImage: avatarImage) { url in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    avatarImage = Image(uiImage: image) }
            }
        } onCancellation: {
            prompt = ""
        }

    }
}

#Preview { ContentView() }
