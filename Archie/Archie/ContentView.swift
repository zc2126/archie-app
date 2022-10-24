//
//  ContentView.swift
//  Archie
//
//  Created by Will Rojas on 10/24/22.
//

import SwiftUI
var options = ["McDonalds","Wendys","fresh&co","Chipotle","Dig","Shake Shack","Pelicana Chicken"]
var out = ""
struct ContentView: View {
    @State private var go = false
    var body: some View {
        Text("Let Archie Decide")
            .padding()
        VStack(alignment: .leading) {
            Button("Go") {
                go.toggle()
                out = options.randomElement()!
            }
            if go {
                Text(out)
            }
        }
    }
}

    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
