//
//  ContentView.swift
//  RubyTalks
//
//  Created by Krassimir Iankov on 4/4/20.
//  Copyright © 2020 Krassimir Iankov. All rights reserved.
//

import SwiftUI
import Combine

struct Talk: Decodable {
    let title, description: String
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
            
            print("completed fetching JSON")
            print(talks)
            
        }.resume()
    }
}


struct ContentView: View {
    
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        NavigationView {
            List (networkManager.talks, id: \.title) {
                Text($0.title)
                }
            }.navigationBarTitle(Text("Ruby Talks"))
        }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
