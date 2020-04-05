//
//  ContentView.swift
//  RubyTalks
//
//  Created by Krassimir Iankov on 4/4/20.
//  Copyright © 2020 Krassimir Iankov. All rights reserved.
//

import SwiftUI
import Combine
import WebKit

struct Talk: Decodable {
    let conference_name, speaker_name, speaker_bio, speaker_twitter, talk_title, talk_description, talk_video: String
}


class NetworkManager: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    @Published var talks = [Talk]() {
        
        didSet {
            self.objectWillChange.send()
        }
    }
    
    init() {
        guard let url = URL(string: "https://ruby-talks-api.herokuapp.com/") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            let talks = try! JSONDecoder().decode([Talk].self, from: data)
            
            DispatchQueue.main.async {
                self.talks = talks
            }
            
//            print("completed fetching JSON")
//            print(talks)
            
        }.resume()
    }
}


struct ContentView: View {
    
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        NavigationView{
            List {
                ForEach(networkManager.talks, id: \.talk_title) { talk in
                    HStack {
                        NavigationLink (destination: WebView(request: URLRequest(url: ((URL(string: talk.talk_video) ?? URL(string: "https://apple.com" ))!)))){
                            Image("cat")
                                .resizable()
                                .scaledToFit()
                                .frame(width:150)
                                .cornerRadius(10)
                            VStack(alignment: .leading){
                                Text(talk.conference_name)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                Text(talk.talk_title)
                                    .font(.headline)
                                    .fontWeight(.black)
                                    .foregroundColor(.primary)
                                    .lineLimit(3)
                                Text(talk.speaker_name)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }.navigationBarTitle(Text("Ruby Talks"))
        }
    }
}


struct WebView : UIViewRepresentable {
    
    let request : URLRequest
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
