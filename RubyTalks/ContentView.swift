//
//  ContentView.swift
//  RubyTalks
//
//  Created by Krassimir Iankov on 4/4/20.
//  Copyright © 2020 Krassimir Iankov. All rights reserved.
//

import SwiftUI



struct ContentView: View {
    var body: some View {
        NavigationView{
            List {
                Text("meow")
            }.navigationBarTitle(Text("Ruby Talks"))
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
