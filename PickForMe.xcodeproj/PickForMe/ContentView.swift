//
//  ContentView.swift
//  PickForMe
//
//  Created by Daniel Jochum on 12/9/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            ItemsView()
                .tabItem {
                    Label("Items", systemImage: "square.and.pencil")
                }

            WheelView()
                .tabItem {
                    Label("Wheel", systemImage: "line.3.crossed.swirl.circle")
                }

            BracketView()
                .tabItem {
                    Label("Bracket", systemImage: "trophy.circle")
                }

            ExtrasView()
                .tabItem {
                    Label("Extras", systemImage: "star")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
