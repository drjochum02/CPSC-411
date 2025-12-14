//
//  BracketView.swift
//  PickForMe
//
//  Created by Daniel Jochum on 12/9/25.
//

import SwiftUI
import CoreData

struct BracketView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default
    )
    private var items: FetchedResults<Item>

    @State private var currentRound: [String] = []
    @State private var nextRound: [String] = []
    @State private var currentMatchIndex = 0

    @State private var champion: String? = nil

    // Color Palette
    let redColor     = Color(red: 0.90, green: 0.20, blue: 0.20)
    let blueColor    = Color(red: 0.20, green: 0.40, blue: 0.90)
    let greenColor   = Color(red: 0.20, green: 0.75, blue: 0.35)
    let yellowColor  = Color(red: 0.95, green: 0.85, blue: 0.25)

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {

                // Champion
                if let champion = champion {

                    Text("🏆 Champion")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(yellowColor)

                    Text(champion)
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(yellowColor.opacity(0.3))
                        .cornerRadius(12)
                        .padding(.horizontal)

                    Button("Restart Bracket") {
                        startBracket()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(blueColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)

                    Spacer()

                // Match View
                } else if currentRound.count >= 2 && currentMatchIndex < currentRound.count - 1 {

                    let left = currentRound[currentMatchIndex]
                    let right = currentRound[currentMatchIndex + 1]

                    Text("Round \(roundNumber())")
                        .font(.title2)
                        .foregroundColor(blueColor)

                    Text("Match \(matchNumber())")
                        .font(.title3)
                        .foregroundColor(.gray)

                    Spacer()

                    VStack(spacing: 20) {

                        Button(action: { advance(winner: left) }) {
                            Text(left)
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(greenColor)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: greenColor.opacity(0.4), radius: 4)
                        }

                        Text("vs")
                            .font(.title2)
                            .bold()
                            .foregroundColor(yellowColor)

                        Button(action: { advance(winner: right) }) {
                            Text(right)
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(redColor)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: redColor.opacity(0.4), radius: 4)
                        }
                    }
                    .padding(.horizontal)

                    Spacer()

                } else {
                    // Not enough items
                    Text("Add more items to start a bracket.")
                        .foregroundColor(.gray)
                }
            }
            .navigationBarTitle("Tournament Bracket")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Tournament Bracket")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }            .onAppear { startBracket() }
        }
    }

    // Start Bracket

    private func startBracket() {
        champion = nil
        nextRound = []
        currentMatchIndex = 0

        let names = items.compactMap { $0.name }
        if names.count < 2 {
            currentRound = []
            return
        }

        // Random order
        currentRound = names.shuffled()
    }

    // Bracket Logic

    private func advance(winner: String) {
        nextRound.append(winner)
        currentMatchIndex += 2

        if currentMatchIndex >= currentRound.count - 1 {
            startNextRound()
        }
    }

    private func startNextRound() {
        if nextRound.count == 1 {
            champion = nextRound.first
            currentRound = []
            return
        }

        currentRound = nextRound
        nextRound = []
        currentMatchIndex = 0
    }

    // UI Helpers

    private func roundNumber() -> Int {
        guard items.count > 1 else { return 1 }
        return Int(log2(Double(items.count))) - Int(log2(Double(currentRound.count))) + 1
    }

    private func matchNumber() -> Int {
        return (currentMatchIndex / 2) + 1
    }
}

struct BracketView_Previews: PreviewProvider {
    static var previews: some View {
        BracketView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
